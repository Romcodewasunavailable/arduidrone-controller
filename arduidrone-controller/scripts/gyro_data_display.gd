@tool
extends DataDisplay


func _on_drone_state_updated() -> void:
	values = Drone.axis_state + Drone.flag_state


func _ready() -> void:
	super._ready()
	if Engine.is_editor_hint():
		return

	keys = Drone.Axis.keys() + Drone.Flag.keys()
	Drone.state_updated.connect(_on_drone_state_updated)
