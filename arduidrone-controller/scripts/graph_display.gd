@tool
class_name GraphDisplay
extends ConnectedElement

@export var title: String:
	set(value):
		if title_label != null:
			title_label.text = value
		title = value

@export var keys := PackedStringArray()
@export var values := PackedFloat32Array()
@export var colors := PackedColorArray()

@export var update_hz: float:
	set(value):
		if update_timer != null and value != 0.0:
			update_timer.wait_time = 1.0 / value
		update_hz = value

@export var graph_origin := Vector2(0.0, 100.0)
@export var graph_scale := Vector2(50.0, 50.0)

@export var max_axis_label_density := 3.0
@export var follow := true
@export var grid_color := Color(0.2, 0.2, 0.2)
@export var zero_color := Color.WHITE

@export var title_label: Label
@export var label_container: Container
@export var graph_control: Control
@export var grid_control: Control
@export var line_control: Control
@export var follow_button: Button
@export var update_timer: Timer

var time: float:
	get():
		return Time.get_ticks_msec() / 1000.0

var graph_size: Vector2:
	get():
		return graph_control.size

var line_label = preload("res://scenes/line_label.tscn")
var point_arrays: Array[PackedVector2Array] = []

var last_keys: PackedStringArray
var last_colors: PackedColorArray


func format_label(value: float) -> String:
	if is_equal_approx(value, round(value)):
		return str(int(value))
	return str(value)


func compute_step(_scale: float, _size: float) -> float:
	var step := pow(10.0, floor(log(1.0 / _scale) / log(10)))
	var parity = false
	while _size / (_scale * step) > max_axis_label_density * _size / 100.0:
		if parity:
			step *= 2
		else:
			step *= 5
		parity = not parity
	return step


func update_labels():
	if label_container == null:
		return
	if line_label == null:
		line_label = load("res://scenes/line_label.tscn")
	
	for i in range(keys.size()):
		var new_line_label: LineLabel
		if i < label_container.get_child_count():
			new_line_label = label_container.get_child(i)
		else:
			new_line_label = line_label.instantiate()
			label_container.add_child(new_line_label)
		
		new_line_label.text = keys[i]
		if i < colors.size():
			new_line_label.color = colors[i]
	
	while label_container.get_child_count() > keys.size():
		var child = label_container.get_child(label_container.get_child_count() - 1)
		label_container.remove_child(child)
		child.queue_free()


func update_grid() -> void:
	for child in grid_control.get_children():
		child.queue_free()
	
	var x_step = compute_step(graph_scale.x * 0.75, graph_size.x)
	var x_start = (floor(-graph_origin.x / graph_scale.x / x_step) + 1) * x_step
	var x = x_start
	while graph_origin.x + x * graph_scale.x < graph_size.x:
		var color_rect = ColorRect.new()
		color_rect.position = Vector2(graph_origin.x + x * graph_scale.x, 0)
		color_rect.size = Vector2(1, graph_size.y)
		color_rect.color = grid_color
		color_rect.mouse_filter = Control.MOUSE_FILTER_PASS
		grid_control.add_child(color_rect)
		
		var label = Label.new()
		label.text = format_label(x)
		label.position = Vector2(-label.get_minimum_size().x / 2.0, graph_size.y + 2)
		color_rect.add_child(label)
		
		x += x_step
	
	var y_step = compute_step(graph_scale.y, graph_size.y)
	var y_start = (floor(-graph_origin.y / graph_scale.y / y_step) + 1) * y_step
	var y = y_start
	while graph_origin.y + y * graph_scale.y < graph_size.y:
		var color_rect = ColorRect.new()
		color_rect.position = Vector2(0, graph_origin.y + y * graph_scale.y)
		color_rect.size = Vector2(graph_size.x, 1)
		color_rect.color = zero_color if is_zero_approx(y) else grid_color
		color_rect.mouse_filter = Control.MOUSE_FILTER_PASS
		grid_control.add_child(color_rect)
		
		var label = Label.new()
		label.text = format_label(-y)
		label.position = Vector2(-label.get_minimum_size().x - 8, -label.get_minimum_size().y / 2.0)
		color_rect.add_child(label)
		
		y += y_step


func update_graph_lines() -> void:
	for i in range(keys.size()):
		var points: PackedVector2Array
		if i < point_arrays.size():
			points = point_arrays[i]
		else:
			points = PackedVector2Array()
			point_arrays.append(points)
		
		if i < values.size():
			points.append(Vector2(time, -values[i]))
		
		var graph_line: Line2D
		if i < line_control.get_child_count():
			graph_line = line_control.get_child(i)
		else:
			graph_line = Line2D.new()
			graph_line.width = 2
			graph_line.joint_mode = Line2D.LINE_JOINT_ROUND
			graph_line.begin_cap_mode = Line2D.LINE_CAP_ROUND
			graph_line.end_cap_mode = Line2D.LINE_CAP_ROUND
			line_control.add_child(graph_line)
		
		if i < colors.size():
			graph_line.default_color = colors[i]
		
		graph_line.clear_points()
		for point in points:
			var graph_point = graph_origin + point * graph_scale
			if not graph_point.x <= graph_size.x: break
			elif (
				not graph_point.x >= 0 
				or not graph_point.y >= 0 
				or not graph_point.y <= graph_size.y
			): continue
			
			graph_line.add_point(graph_point)
	
	while point_arrays.size() > keys.size():
		point_arrays.remove_at(-1)
	
	while line_control.get_child_count() > keys.size():
		var graph_line = line_control.get_child(line_control.get_child_count() - 1)
		line_control.remove_child(graph_line)
		graph_line.queue_free()


func _on_clear_button_pressed() -> void:
	point_arrays.clear()


func _on_follow_button_toggled(toggled_on: bool) -> void:
	follow = toggled_on


func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		var zoom_factor := 1.1
		var scale_change := 1.0

		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			scale_change = zoom_factor
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			scale_change = 1.0 / zoom_factor
		else:
			return

		if Input.is_key_pressed(KEY_ALT):
			var new_scale = graph_scale.x * scale_change
			if follow:
				graph_scale.x = new_scale
			else:
				var center_to_origin = (graph_origin.x - graph_size.x / 2.0) / graph_scale.x
				graph_scale.x = new_scale
				graph_origin.x = graph_size.x / 2.0 + center_to_origin * graph_scale.x
		elif Input.is_key_pressed(KEY_CTRL):
			graph_scale.y *= scale_change
		elif Input.is_key_pressed(KEY_SHIFT):
			if follow:
				follow_button.button_pressed = false
			graph_origin.x += (scale_change - 1.0) * 100
		else:
			graph_origin.y += (scale_change - 1.0) * 100


func _on_update_timer_timeout() -> void:
	if graph_control == null or grid_control == null or line_control == null:
		return
	
	if follow:
		graph_origin.x = graph_size.x - time * graph_scale.x
	
	update_grid()
	update_graph_lines()


func _process(_delta: float) -> void:
	super._process(_delta)
	if keys != last_keys or colors != last_colors:
		update_labels()
		last_keys = keys
		last_colors = colors
	
	if Engine.is_editor_hint():
		return
	
	values[0] = sin(time)
	values[1] = cos(time)
