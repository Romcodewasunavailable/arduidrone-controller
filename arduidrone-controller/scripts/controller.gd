extends Node

signal state_updated()

enum Axis {
	THROTTLE,
	YAW,
	PITCH,
	ROLL,
	TILT_ANGLE_P, # 3.0
	TILT_ANGLE_I, # 0.0
	TILT_ANGLE_D, # 0.04
	TILT_RATE_P, # 0.35
	TILT_RATE_I, # 0.1
	TILT_RATE_D, # 0.02
	YAW_RATE_P, # 2.0
	YAW_RATE_I,
	YAW_RATE_D,
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
	KEY_HOME: Flag.TOGGLE_ARM,
	JOY_BUTTON_START: Flag.TOGGLE_ARM,
	JOY_BUTTON_RIGHT_SHOULDER: Flag.TOGGLE_ARM,
	JOY_BUTTON_DPAD_DOWN: Flag.THROTTLE_DOWN,
	JOY_BUTTON_DPAD_UP: Flag.THROTTLE_UP,
}
const DJI_AXIS_MAP = {
	JOY_AXIS_RIGHT_X: Axis.THROTTLE,
	JOY_AXIS_RIGHT_Y: Axis.YAW,
	JOY_AXIS_LEFT_Y: Axis.PITCH,
	JOY_AXIS_LEFT_X: Axis.ROLL,
}
const DJI_FLAG_MAP = {
	KEY_HOME: Flag.TOGGLE_ARM,
	JOY_BUTTON_B: Flag.TOGGLE_ARM,
	JOY_BUTTON_X: Flag.THROTTLE_DOWN,
	JOY_BUTTON_Y: Flag.THROTTLE_UP,
}

const DJI_MAX_AXIS_VALUE = 0.6445

var update_timer: Timer

var precision = 0.01
var deadzone = 0.1
var send_udp = true
var dji_controller = true

var axis_state = []
var flag_state = []


func set_precision(step_value: float) -> void:
	precision = step_value


func set_deadzone(min_value: float) -> void:
	deadzone = min_value


func set_poll_rate(rate_hz: float) -> void:
	update_timer.wait_time = 1.0 / rate_hz


func set_send_udp(toggled_on: bool) -> void:
	send_udp = toggled_on


func set_dji_controller(toggled_on: float) -> void:
	dji_controller = toggled_on


func process_axis(value: float) -> float:
	if dji_controller:
		value /= DJI_MAX_AXIS_VALUE
	return snapped(value, precision) if abs(value) > deadzone else 0.0


func _on_update_timer_timeout() -> void:
	if send_udp:
		UDP.send([axis_state, flag_state])
	state_updated.emit()


func _input(event: InputEvent) -> void:
	var axis_map = DJI_AXIS_MAP if dji_controller else AXIS_MAP
	var flag_map = DJI_FLAG_MAP if dji_controller else FLAG_MAP

	if event is InputEventJoypadMotion:
		if axis_map.has(event.axis):
			if dji_controller and event.axis in [JOY_AXIS_RIGHT_X, JOY_AXIS_LEFT_Y]:
				axis_state[axis_map[event.axis]] = -process_axis(event.axis_value)
			else:
				axis_state[axis_map[event.axis]] = process_axis(event.axis_value)
	elif event is InputEventJoypadButton:
		if flag_map.has(event.button_index):
			flag_state[flag_map[event.button_index]] = event.pressed
	elif event is InputEventKey:
		if flag_map.has(event.keycode):
			flag_state[flag_map[event.keycode]] = event.pressed


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
