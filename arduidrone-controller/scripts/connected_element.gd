@tool
class_name ConnectedElement
extends DragResizeBox

@export var line_anchor: Vector2:
	set(value):
		line_anchor = value
		if is_node_ready():
			update_line()

@export var line: Line2D

var last_position: Vector2
var last_size: Vector2
var last_container_size: Vector2


func update_line():
	var center = size / 2.0
	var end = line_anchor - position
	
	var mid: Vector2
	var dx = abs(center.x - end.x)
	var dy = abs(center.y - end.y)
	
	if dx < dy:
		mid = Vector2(center.x, end.y + dx * sign(center.y - end.y))
	else:
		mid = Vector2(end.x + dy * sign(center.x - end.x), center.y)
	
	line.set_point_position(0, center)
	line.set_point_position(1, mid)
	line.set_point_position(2, end)


func _ready() -> void:
	update_line()


func _process(_delta):
	if position != last_position:
		update_line()
		last_position = position
	
	if size != last_size or main_control.size != last_container_size:
		if size != last_size:
			main_control.size = size
		else:
			size = main_control.size
		
		update_line()
		last_size = size
		last_container_size = size
