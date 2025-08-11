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
	axis_state.resize(Axis.size())
	axis_state.fill(0.0)
	flag_state.resize(Flag.size())
	flag_state.fill(false)
	state_updated.emit()
