@tool
class_name DataEntryDisplay
extends Control

@export var key: String:
	set(new_value):
		key = new_value
		if key_label != null:
			key_label.text = new_value

@export var value: Variant = null:
	set(new_value):
		value = new_value
		if value_label != null:
			value_label.text = str(new_value)

@export var key_label: Label
@export var value_label: Label
