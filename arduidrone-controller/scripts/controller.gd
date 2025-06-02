extends Node

enum {THROTTLE, YAW, PITCH, ROLL}
enum {TEST}

var update_timer: Timer

var precision = 0.0
var deadzone = 0.05
var axis_map = {
	JOY_AXIS_LEFT_Y: THROTTLE,
	JOY_AXIS_LEFT_X: YAW,
	JOY_AXIS_RIGHT_Y: PITCH,
	JOY_AXIS_RIGHT_X: ROLL,
}
var button_map = {JOY_BUTTON_RIGHT_SHOULDER: TEST}
var axis_state = []
var button_state = []


func set_poll_rate(rate_hz: float) -> void:
	update_timer.wait_time = 1.0 / rate_hz


func process_axis(value: float) -> float:
	return snapped(value, precision) if abs(value) > deadzone else 0.0


func _on_update_timer_timeout() -> void:
	UDP.send([axis_state, button_state])


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
