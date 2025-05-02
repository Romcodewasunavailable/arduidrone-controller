@tool
class_name LineConnector
extends Control

@export var line_anchor: Vector2 = Vector2.ZERO:
	set(value):
		line_anchor = value
		update_line()

@export var line: Line2D

var last_position: Vector2
var last_size: Vector2


func update_line():
	if line == null:
		return
	
	var center = size * 0.5
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


func _process(_delta):
	if position != last_position:
		update_line()
		last_position = position
	if size != last_size:
		update_line()
		last_size = size
