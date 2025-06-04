extends Node

signal updated()

enum AXES {THROTTLE, YAW, PITCH, ROLL}
enum BUTTONS {IDLE_THRUST_UP, IDLE_THRUST_DOWN}

var update_timer: Timer

var precision = 0.01
var deadzone = 0.05
var axis_map = {
	JOY_AXIS_LEFT_Y: AXES.THROTTLE,
	JOY_AXIS_LEFT_X: AXES.YAW,
	JOY_AXIS_RIGHT_Y: AXES.PITCH,
	JOY_AXIS_RIGHT_X: AXES.ROLL,
}
var button_map = {
	JOY_BUTTON_DPAD_UP: BUTTONS.IDLE_THRUST_UP,
	JOY_BUTTON_DPAD_DOWN: BUTTONS.IDLE_THRUST_DOWN,
}
var axis_state = []
var button_state = []


func set_poll_rate(rate_hz: float) -> void:
	update_timer.wait_time = 1.0 / rate_hz


func process_axis(value: float) -> float:
	return snapped(value, precision) if abs(value) > deadzone else 0.0


func _on_update_timer_timeout() -> void:
	UDP.send([axis_state, button_state])

	updated.emit()


func _input(event: InputEvent) -> void:
	if event is InputEventJoypadMotion:
		if axis_map.has(event.axis):
			axis_state[axis_map[event.axis]] = process_axis(event.axis_value)
	elif event is InputEventJoypadButton:
		if button_map.has(event.button_index):
			button_state[button_map[event.button_index]] = event.pressed


func _ready() -> void:
	axis_state.resize(axis_map.size())
	axis_state.fill(0.0)
	button_state.resize(button_map.size())
	button_state.fill(false)

	update_timer = Timer.new()
	update_timer.wait_time = 1.0 / 60.0
	update_timer.connect("timeout", _on_update_timer_timeout)
	add_child(update_timer)
	update_timer.start()
