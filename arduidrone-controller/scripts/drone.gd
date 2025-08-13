extends Node

signal state_updated()

enum Axis {
	RPM_1,
	RPM_2,
	RPM_3,
	RPM_4,
	YAW,
	PITCH,
	ROLL,
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
