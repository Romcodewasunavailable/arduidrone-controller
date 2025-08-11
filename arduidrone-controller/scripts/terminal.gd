@tool
class_name Terminal
extends TitledConnectedElement

@export var entries := PackedStringArray():
	set(value):
		entries = value
		if is_node_ready():
			update_terminal_label()
			update_scroll()

@export var max_entries := 200
@export var follow := true
@export var command_script: Script

@export var scroll_container: ScrollContainer
@export var scrolled_container: Container
@export var terminal_label: RichTextLabel
@export var button_margin_container: MarginContainer
@export var command_line_edit: LineEdit

var commands: Commands

var last_scroll_size: Vector2
var last_scrolled_size: Vector2
var last_scrolled_position: Vector2


func add_entry(entry: String) -> void:
	entries.append(entry)
	if entries.size() > max_entries:
		entries.remove_at(0)
	update_terminal_label()
	update_scroll()


func update_terminal_label() -> void:
	terminal_label.text = "\n".join(entries)


func update_scroll() -> void:
	if follow:
		scroll_container.scroll_vertical = int(scroll_container.get_v_scroll_bar().max_value)


func update_button_margin() -> void:
	button_margin_container.add_theme_constant_override("margin_right", 12 if scrolled_container.size.y > scroll_container.size.y else 4)


func _on_command_output(message: String) -> void:
	add_entry(message)


func _on_scroll_container_zoom(direction: int) -> void:
	var new_font_size = max(terminal_label.get_theme_font_size("normal_font_size") + direction, 1)
	terminal_label.add_theme_font_size_override("normal_font_size", new_font_size)
	command_line_edit.add_theme_font_size_override("font_size", new_font_size)


func _on_follow_button_toggled(toggled_on: bool) -> void:
	follow = toggled_on


func _on_clear_button_pressed() -> void:
	entries.clear()


func _on_command_line_edit_text_submitted(command: String) -> void:
	entries.append("> " + command)
	command_line_edit.clear()

	var expression = Expression.new()
	var err = expression.parse(command)
	if err != OK:
		add_entry(expression.get_error_text())
		return
	var result = expression.execute([], commands)
	if expression.has_execute_failed():
		add_entry(expression.get_error_text())
		return
	if result != null:
		add_entry(str(result))


func _ready() -> void:
	super._ready()
	if Engine.is_editor_hint():
		return

	update_terminal_label()
	update_scroll()
	if command_script != null:
		commands = command_script.new()
		commands.output.connect(_on_command_output)
		commands._ready()


func _process(_delta: float) -> void:
	super._process(_delta)
	if not Engine.is_editor_hint():
		commands._process(_delta)

	if (
		scroll_container.size != last_scroll_size
		or scrolled_container.size != last_scrolled_size
		or scrolled_container.position != last_scrolled_position
	):
		update_button_margin()
		if scrolled_container.size != last_scrolled_size:
			update_scroll()
		last_scroll_size = scroll_container.size
		last_scrolled_size = scrolled_container.size
		last_scrolled_position = scrolled_container.position
