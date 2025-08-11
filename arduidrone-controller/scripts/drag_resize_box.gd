extends Control
class_name DragResizeBox

enum Mode {
	NONE,
	DRAG,
	RESIZE,
}
enum ResizeEdge {
	NONE,
	LEFT,
	RIGHT,
	TOP,
	BOTTOM,
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT,
}

const RESIZE_MARGIN := 10

@export var resizeable := true
@export var main_control: Control

var minimum_size := Vector2(RESIZE_MARGIN * 2, RESIZE_MARGIN * 2):
	get():
		return main_control.get_minimum_size().max(main_control.custom_minimum_size)

var current_mode := Mode.NONE
var current_resize_edge := ResizeEdge.NONE


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var local_mouse_position := get_local_mouse_position()
			current_resize_edge = _detect_resize_edge(local_mouse_position)
			if resizeable and current_resize_edge != ResizeEdge.NONE:
				current_mode = Mode.RESIZE
			else:
				current_mode = Mode.DRAG
		else:
			current_mode = Mode.NONE
			current_resize_edge = ResizeEdge.NONE

	elif event is InputEventMouseMotion:
		if current_mode == Mode.NONE:
			_update_mouse_cursor(get_local_mouse_position())
		elif event.button_mask & MOUSE_BUTTON_MASK_LEFT:
			if current_mode == Mode.DRAG:
				global_position += event.relative
			elif current_mode == Mode.RESIZE:
				_resize(event.position)


func _detect_resize_edge(mouse_position: Vector2) -> ResizeEdge:
	var on_left := mouse_position.x <= RESIZE_MARGIN
	var on_right := mouse_position.x >= size.x - RESIZE_MARGIN
	var on_top := mouse_position.y <= RESIZE_MARGIN
	var on_bottom := mouse_position.y >= size.y - RESIZE_MARGIN

	if on_left and on_top:
		return ResizeEdge.TOP_LEFT
	if on_right and on_top:
		return ResizeEdge.TOP_RIGHT
	if on_left and on_bottom:
		return ResizeEdge.BOTTOM_LEFT
	if on_right and on_bottom:
		return ResizeEdge.BOTTOM_RIGHT
	if on_left:
		return ResizeEdge.LEFT
	if on_right:
		return ResizeEdge.RIGHT
	if on_top:
		return ResizeEdge.TOP
	if on_bottom:
		return ResizeEdge.BOTTOM

	return ResizeEdge.NONE


func _update_mouse_cursor(mouse_position: Vector2) -> void:
	match _detect_resize_edge(mouse_position):
		ResizeEdge.TOP_LEFT, ResizeEdge.BOTTOM_RIGHT:
			mouse_default_cursor_shape = Control.CURSOR_FDIAGSIZE
		ResizeEdge.TOP_RIGHT, ResizeEdge.BOTTOM_LEFT:
			mouse_default_cursor_shape = Control.CURSOR_BDIAGSIZE
		ResizeEdge.LEFT, ResizeEdge.RIGHT:
			mouse_default_cursor_shape = Control.CURSOR_HSIZE
		ResizeEdge.TOP, ResizeEdge.BOTTOM:
			mouse_default_cursor_shape = Control.CURSOR_VSIZE
		_:
			mouse_default_cursor_shape = Control.CURSOR_ARROW


func _resize(mouse_position: Vector2) -> void:
	var new_position := position
	var new_size := size

	match current_resize_edge:
		ResizeEdge.LEFT:
			new_position.x += mouse_position.x
			new_size.x -= mouse_position.x
		ResizeEdge.RIGHT:
			new_size.x = mouse_position.x
		ResizeEdge.TOP:
			new_position.y += mouse_position.y
			new_size.y -= mouse_position.y
		ResizeEdge.BOTTOM:
			new_size.y = mouse_position.y
		ResizeEdge.TOP_LEFT:
			new_position += mouse_position
			new_size -= mouse_position
		ResizeEdge.TOP_RIGHT:
			new_position.y += mouse_position.y
			new_size.x = mouse_position.x
			new_size.y -= mouse_position.y
		ResizeEdge.BOTTOM_LEFT:
			new_position.x += mouse_position.x
			new_size.x -= mouse_position.x
			new_size.y = mouse_position.y
		ResizeEdge.BOTTOM_RIGHT:
			new_size = mouse_position

	new_position = new_position.min(position + size - minimum_size)
	new_size = new_size.max(minimum_size)

	position = new_position
	size = new_size
