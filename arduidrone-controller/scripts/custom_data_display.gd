@tool
class_name CustomDataDisplay
extends TitledConnectedElement

const CUSTOM_DATA_ENTRY_DISPLAY = preload("res://scenes/custom_data_entry_display.tscn")

@export var entry_container: Container


func _ready() -> void:
	super._ready()


func update_key_ask() -> void:
	Controller.axis_ask.clear()
	Controller.flag_ask.clear()
	for entry: CustomDataEntryDisplay in entry_container.get_children():
		var option = entry.key_option_button.selected
		if option < Drone.Axis.size():
			if option not in Controller.axis_ask:
				Controller.axis_ask.append(option)
		elif option - Drone.Axis.size() not in Controller.flag_ask:
			Controller.flag_ask.append(option - Drone.Axis.size())
	print(Controller.flag_ask)


func _on_remove_entry_button_pressed() -> void:
	if entry_container.get_child_count() > 0:
		var entry: CustomDataEntryDisplay = entry_container.get_child(-1)
		entry.key_changed.disconnect(update_key_ask)
		entry_container.remove_child(entry)
		entry.queue_free()
	update_key_ask()


func _on_add_entry_button_pressed() -> void:
	var new_entry: CustomDataEntryDisplay = CUSTOM_DATA_ENTRY_DISPLAY.instantiate()
	new_entry.key_changed.connect(update_key_ask)
	entry_container.add_child(new_entry)
	update_key_ask()
