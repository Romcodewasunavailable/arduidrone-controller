@tool
class_name LineLabel
extends Control

@export var color: Color = Color.WHITE:
	set(value):
		color = value
		if is_node_ready():
			color_rect.color = color

@export var text: String:
	set(value):
		text = value
		if is_node_ready():
			label.text = text

@export var color_rect: ColorRect
@export var label: Label


func _ready() -> void:
	color_rect.color = color
	label.text = text
