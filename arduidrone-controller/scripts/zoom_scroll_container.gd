extends ScrollContainer

signal zoom(direction: int)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
		if Input.is_key_pressed(KEY_CTRL):
			get_viewport().set_input_as_handled()
			var direction = 1 if event.button_index == MOUSE_BUTTON_WHEEL_UP else -1
			zoom.emit(direction)
