extends ScrollContainer

signal zoom(direction: int)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and Input.is_key_pressed(KEY_CTRL):
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			get_viewport().set_input_as_handled()
			zoom.emit(1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			get_viewport().set_input_as_handled()
			zoom.emit(-1)
