@tool
class_name LineLabel
extends Control

@export var color: Color = Color.WHITE:
	set(value):
		color = value
		if color_rect != null:
			color_rect.color = value

@export var text: String:
	set(value):
		text = value
		if label != null:
			label.text = value

@export var color_rect: ColorRect
@export var label: Label
