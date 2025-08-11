@tool
extends DataDisplay


func _on_controller_state_updated() -> void:
	values = Controller.axis_state + Controller.flag_state


func _ready() -> void:
	super._ready()
	if Engine.is_editor_hint():
		return

	keys = Controller.Axis.keys() + Controller.Flag.keys()
	Controller.state_updated.connect(_on_controller_state_updated)
