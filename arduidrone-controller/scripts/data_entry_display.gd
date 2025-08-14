@tool
class_name DataEntryDisplay
extends Control

const FLOAT_SNAP = 0.01

@export var key: String:
	set(new_value):
		key = new_value
		if is_node_ready():
			key_label.text = key.capitalize()

@export var value: Variant = null:
	set(new_value):
		value = new_value
		if is_node_ready():
			value_label.text = str(snapped(value, FLOAT_SNAP) if value is float else value)

@export var key_label: Label
@export var value_label: Label


func _ready() -> void:
	key_label.text = key.capitalize()
	value_label.text = str(value)
