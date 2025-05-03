@tool
class_name GraphDisplay
extends ConnectedElement

@export var graph_origin := Vector2(0.0, 100.0)
@export var graph_scale := Vector2(37.5, 25.0)
@export var grid_color := Color(0.2, 0.2, 0.2)
@export var graph_control: Control


func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		print("Mouse clicked on control")
	elif event is InputEventMouseMotion:
		print("Mouse moved inside control")


func update_graph() -> void:
	if graph_control == null:
		return
	
	for child in graph_control.get_children():
		graph_control.remove_child(child)
		child.queue_free()
	
	for i in range(
		-floori(graph_origin.x / graph_scale.x),
		ceili((graph_control.size.x - graph_origin.x) / graph_scale.x),
	):
		var new_color_rect = ColorRect.new()
		new_color_rect.position = Vector2(graph_origin.x + i * graph_scale.x, 0)
		new_color_rect.size = Vector2(1, graph_control.size.y)
		new_color_rect.color = grid_color
		graph_control.add_child(new_color_rect)


func _process(_delta: float) -> void:
	super._process(_delta)
	update_graph()
