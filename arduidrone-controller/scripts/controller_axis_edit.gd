@tool
class_name ControllerAxisEdit
extends Control

@export var controller_axis: Controller.Axis:
	set(value):
		controller_axis = value
		axis_name_label.text = Controller.Axis.keys()[controller_axis].capitalize()

@export var axis_name_label: Label
@export var axis_value_line_edit: LineEdit


func _ready() -> void:
	axis_value_line_edit.text = str(Controller.axis_state[controller_axis])


func _on_axis_value_line_edit_text_submitted(new_text: String) -> void:
	Controller.axis_state[controller_axis] = float(new_text)
