extends Node

signal state_updated()

enum Axis {
	THROTTLE,
	YAW,
	PITCH,
	ROLL,
	PITCH_ANGLE_P, #3
	PITCH_ANGLE_I, #0.1
	PITCH_ANGLE_D, #0.018
	PITCH_RATE_P, #0.85
	PITCH_RATE_I, #0.1
	PITCH_RATE_D, #0.035
	GYRO_RATE_ALPHA, #0.95
}
enum Flag {
	TOGGLE_ARM,
	THROTTLE_DOWN,
	THROTTLE_UP,
}

const AXIS_MAP = {
	JOY_AXIS_LEFT_Y: Axis.THROTTLE,
	JOY_AXIS_LEFT_X: Axis.YAW,
	JOY_AXIS_RIGHT_Y: Axis.PITCH,
	JOY_AXIS_RIGHT_X: Axis.ROLL,
}
const FLAG_MAP = {
	KEY_KP_ENTER: Flag.TOGGLE_ARM,
	JOY_BUTTON_START: Flag.TOGGLE_ARM,
	JOY_BUTTON_RIGHT_SHOULDER: Flag.TOGGLE_ARM,
	JOY_BUTTON_DPAD_DOWN: Flag.THROTTLE_DOWN,
	JOY_BUTTON_DPAD_UP: Flag.THROTTLE_UP,
}

var update_timer: Timer

var precision = 0.01
var deadzone = 0.05
var send_udp = true

var axis_state = []
var flag_state = []


func set_precision(step_value: float) -> void:
	precision = step_value


func set_deadzone(min_value: float) -> void:
	deadzone = min_value


func set_send_udp(toggled_on: bool) -> void:
	send_udp = toggled_on


func set_poll_rate(rate_hz: float) -> void:
	update_timer.wait_time = 1.0 / rate_hz


func process_axis(value: float) -> float:
	return snapped(value, precision) if abs(value) > deadzone else 0.0


func _on_update_timer_timeout() -> void:
	if send_udp:
		UDP.send([axis_state, flag_state])
	state_updated.emit()


func _input(event: InputEvent) -> void:
	if event is InputEventJoypadMotion:
		if AXIS_MAP.has(event.axis):
			axis_state[AXIS_MAP[event.axis]] = process_axis(event.axis_value)
	elif event is InputEventJoypadButton:
		if FLAG_MAP.has(event.button_index):
			flag_state[FLAG_MAP[event.button_index]] = event.pressed
	elif event is InputEventKey:
		if FLAG_MAP.has(event.keycode):
			flag_state[FLAG_MAP[event.keycode]] = event.pressed


func _ready() -> void:
	axis_state.resize(Axis.size())
	axis_state.fill(0.0)
	flag_state.resize(Flag.size())
	flag_state.fill(false)
	state_updated.emit()

	update_timer = Timer.new()
	update_timer.wait_time = 1.0 / 60.0
	update_timer.timeout.connect(_on_update_timer_timeout)
	add_child(update_timer)
	update_timer.start()
