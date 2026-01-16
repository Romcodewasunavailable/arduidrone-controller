@tool
class_name CustomLineEntry
extends Control

signal key_changed
signal color_changed

@export var key := 0
@export var color := Color.WHITE

@export var key_option_button: OptionButton
@export var color_picker_button: ColorPickerButton


func _ready() -> void:
	update_key_items()


func update_key_items() -> void:
	key_option_button.clear()
	for axis: String in Drone.Axis:
		key_option_button.add_item(axis.capitalize())


func _on_key_option_button_item_selected(index: int) -> void:
	key = index
	key_changed.emit()


func _on_color_picker_button_color_changed(color: Color) -> void:
	self.color = color
	color_changed.emit()
