@tool
class_name ArduidroneController
extends Control

@export var zoom_factor := 1.1


func _unhandled_input(event: InputEvent) -> void:
	var hovered = get_viewport().gui_get_hovered_control()
	if hovered != null and hovered != self:
		return

	if Input.is_key_pressed(KEY_CTRL) and event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			scale /= zoom_factor
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			scale *= zoom_factor
