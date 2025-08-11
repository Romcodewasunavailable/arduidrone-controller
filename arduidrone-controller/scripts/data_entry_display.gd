@tool
class_name DataEntryDisplay
extends Control

@export var key: String:
	set(new_value):
		key = new_value
		if is_node_ready():
			key_label.text = key.capitalize()

@export var value: Variant = null:
	set(new_value):
		value = new_value
		if is_node_ready():
			value_label.text = str(value)

@export var key_label: Label
@export var value_label: Label


func _ready() -> void:
	key_label.text = key.capitalize()
	value_label.text = str(value)
