@tool
extends DataDisplay


func _on_controller_updated() -> void:
	values = Controller.axis_state + Controller.button_state


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	keys = Controller.AXES.keys() + Controller.BUTTONS.keys()
	Controller.connect("updated", _on_controller_updated)
