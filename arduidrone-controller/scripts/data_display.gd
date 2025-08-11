@tool
class_name DataDisplay
extends TitledConnectedElement

signal data_updated()

const DATA_ENTRY_DISPLAY = preload("res://scenes/data_entry_display.tscn")

@export var keys: PackedStringArray:
	set(value):
		keys = value
		if is_node_ready():
			update_data_entry_displays()
			data_updated.emit()
@export var values: Array[Variant]:
	set(value):
		values = value
		if is_node_ready():
			update_data_entry_displays()
			data_updated.emit()

@export var entry_container: Container


func update_data_entry_displays() -> void:
	for i in range(keys.size()):
		var new_data_entry_display: DataEntryDisplay
		if i < entry_container.get_child_count():
			new_data_entry_display = entry_container.get_child(i)
		else:
			new_data_entry_display = DATA_ENTRY_DISPLAY.instantiate()
			entry_container.add_child(new_data_entry_display)

		new_data_entry_display.key = keys[i]
		if i < values.size():
			new_data_entry_display.value = values[i]

	while entry_container.get_child_count() > keys.size():
		var child = entry_container.get_child(entry_container.get_child_count() - 1)
		entry_container.remove_child(child)
		child.queue_free()


func _ready() -> void:
	super._ready()
	update_data_entry_displays()
	data_updated.emit()
