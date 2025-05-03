@tool
class_name DataDisplay
extends ConnectedElement

@export var title: String:
	set(value):
		if title_label != null:
			title_label.text = value
		title = value

@export var keys: PackedStringArray
@export var values: Array[Variant]

@export var title_label: Label
@export var entry_container: Container

var data_entry_display = preload("res://scenes/data_entry_display.tscn")

var last_keys: PackedStringArray
var last_values: Array[Variant]


func update_data():
	if data_entry_display == null:
		data_entry_display = load("res://scenes/data_entry_display.tscn")
	
	for i in range(keys.size()):
		var entry_display: DataEntryDisplay
		if i < entry_container.get_child_count():
			entry_display = entry_container.get_child(i)
		else:
			entry_display = data_entry_display.instantiate()
			entry_container.add_child(entry_display)
		
		entry_display.key = keys[i]
		if i < values.size():
			entry_display.value = values[i]
	
	while entry_container.get_child_count() > keys.size():
		var entry_display = entry_container.get_child(entry_container.get_child_count() - 1)
		entry_container.remove_child(entry_display)
		entry_display.queue_free()


func _process(_delta):
	super._process(_delta)
	if keys != last_keys or values != last_values:
		update_data()
		last_keys = keys
		last_values = values
