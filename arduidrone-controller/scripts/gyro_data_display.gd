@tool
extends DataDisplay


func _on_drone_state_updated() -> void:
	#values = object[1]
	pass


func _ready() -> void:
	super._ready()
	if Engine.is_editor_hint():
		return

	keys = Drone.Axis.keys().slice(4)
	Drone.state_updated.connect(_on_drone_state_updated)
