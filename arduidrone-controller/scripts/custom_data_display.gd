@tool
class_name CustomDataDisplay
extends TitledConnectedElement

const CUSTOM_DATA_ENTRY_DISPLAY = preload("res://scenes/custom_data_entry_display.tscn")

@export var entry_container: Container


func _ready() -> void:
	super._ready()


func _on_remove_entry_button_pressed() -> void:
	if entry_container.get_child_count() <= 0:
		return

	var entry: CustomDataEntryDisplay = entry_container.get_child(-1)
	entry.key_changed.disconnect(Controller.update_ask)
	Drone.state_updated.disconnect(entry.update_value)
	entry_container.remove_child(entry)
	entry.queue_free()
	Controller.update_ask()


func _on_add_entry_button_pressed() -> void:
	var new_entry: CustomDataEntryDisplay = CUSTOM_DATA_ENTRY_DISPLAY.instantiate()
	new_entry.key_changed.connect(Controller.update_ask)
	Drone.state_updated.connect(new_entry.update_value)
	entry_container.add_child(new_entry)
	Controller.update_ask()
