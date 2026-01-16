@tool
class_name CustomDataEntryDisplay
extends Control

signal key_changed

const FLOAT_SNAP = 0.01

@export var key := 0
@export var value: Variant:
	set(new_value):
		value = new_value
		value_label.text = str(snapped(value, FLOAT_SNAP) if value is float else value)

@export var key_option_button: OptionButton
@export var value_label: Label


func _ready() -> void:
	update_key_items()


func update_key_items() -> void:
	key_option_button.clear()
	for axis: String in Drone.Axis:
		key_option_button.add_item(axis.capitalize())
	for flag: String in Drone.Flag:
		key_option_button.add_item(flag.capitalize())


func update_value() -> void:
	if key_option_button.selected < Drone.Axis.size():
		value = Drone.axis_state[key_option_button.selected]
	else:
		value = Drone.flag_state[key_option_button.selected - Drone.Axis.size()]


func _on_key_option_button_item_selected(index: int) -> void:
	key = index
	key_changed.emit()
