@tool
extends GraphDisplay

@export var controller_data_display: DataDisplay


func _on_controller_data_display_updated() -> void:
	keys = controller_data_display.keys.slice(0, 4)
	values = controller_data_display.values.slice(0, 4)


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	controller_data_display.connect("updated", _on_controller_data_display_updated)
