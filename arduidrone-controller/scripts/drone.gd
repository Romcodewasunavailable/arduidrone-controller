extends Node

signal state_updated()

enum Axis {
	THROTTLE_1,
	THROTTLE_2,
	THROTTLE_3,
	THROTTLE_4,
	VELOCITY_X,
	VELOCITY_Y,
	VELOCITY_Z,
	PITCH,
	ROLL,
	YAW,
	PITCH_RATE,
	ROLL_RATE,
	YAW_RATE,
	FLOW_X,
	FLOW_Y,
	FLOW_HEIGHT,
	LOOP_FREQUENCY,
	PITCH_ANGLE_PID_INPUT,
	PITCH_ANGLE_PID_OUTPUT,
	PITCH_ANGLE_PID_SETPOINT,
	PITCH_RATE_PID_INPUT,
	PITCH_RATE_PID_OUTPUT,
	PITCH_RATE_PID_SETPOINT,
	ROLL_ANGLE_PID_INPUT,
	ROLL_ANGLE_PID_OUTPUT,
	ROLL_ANGLE_PID_SETPOINT,
	ROLL_RATE_PID_INPUT,
	ROLL_RATE_PID_OUTPUT,
	ROLL_RATE_PID_SETPOINT,
	YAW_RATE_PID_INPUT,
	YAW_RATE_PID_OUTPUT,
	YAW_RATE_PID_SETPOINT,
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
		print(Controller.flag_ask)
		for i in range(mini(object[0].size(), Controller.axis_ask.size())):
			axis_state[Controller.axis_ask[i]] = object[0][i]
		for i in range(mini(object[1].size(), Controller.flag_ask.size())):
			flag_state[Controller.flag_ask[i]] = object[1][i]
		state_updated.emit()
