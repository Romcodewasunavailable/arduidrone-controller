extends Node

signal state_updated()

enum Axis {
	THROTTLE_1,
	THROTTLE_2,
	THROTTLE_3,
	THROTTLE_4,
	PITCH,
	ROLL,
	YAW,
	VELOCITY_X,
	VELOCITY_Y,
	VELOCITY_Z,
	PITCH_ANGLE_PID_INPUT,
	PITCH_ANGLE_PID_OUTPUT,
	PITCH_ANGLE_PID_SETPOINT,
	YAW_RATE_PID_INPUT,
	YAW_RATE_PID_OUTPUT,
	YAW_RATE_PID_SETPOINT,
	VOLTAGE,
	BATTERY,
}
enum Flag {
	IS_ARMED,
}

var axis_state = []
var flag_state = []


func _ready() -> void:
	UDP.received.connect(_on_udp_received)
	axis_state.resize(Axis.size())
	axis_state.fill(0.0)
	flag_state.resize(Flag.size())
	flag_state.fill(false)
	state_updated.emit()


func _on_udp_received(object: Variant, _ip: String, _port: int) -> void:
	if (object is Array
	and len(object) == 2
	and object[0] is Array
	and object[1] is Array):
		for i in range(len(object[0])):
			axis_state[i] = object[0][i]
		for i in range(len(object[1])):
			flag_state[i] = object[1][i]
		state_updated.emit()
