@tool
class_name Terminal
extends ConnectedElement

@export var title: String:
	set(value):
		title = value
		if title_label != null:
			title_label.text = value

@export var entries := PackedStringArray()

@export var follow := true

@export var title_label: Label
@export var scroll_container: ScrollContainer
@export var scrolled_container: Container
@export var terminal_label: RichTextLabel
@export var button_container: Container
@export var follow_button: Button
@export var command_line_edit: LineEdit

var last_scroll_size: Vector2
var last_scrolled_size: Vector2
var last_scrolled_position: Vector2
var last_entries: PackedStringArray


func update_terminal_label() -> void:
	terminal_label.text = "\n".join(entries)


func update_scroll() -> void:
	if follow:
		scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value


func update_button_container() -> void:
	pass


func _on_follow_button_toggled(toggled_on: bool) -> void:
	follow = toggled_on


func _on_clear_button_pressed() -> void:
	entries.clear()


func _on_command_line_edit_text_submitted(command: String) -> void:
	entries.append(command)
	command_line_edit.clear()


func _process(_delta: float) -> void:
	super._process(_delta)

	if entries != last_entries:
		update_terminal_label()
		last_entries = entries.duplicate()

	if (
		scroll_container.size != last_scroll_size
		or scrolled_container.size != last_scrolled_size
		or scrolled_container.position != last_scrolled_position
	):
		update_button_container()
		if scrolled_container.size != last_scrolled_size:
			update_scroll()
		last_scroll_size = scroll_container.size
		last_scrolled_size = scrolled_container.size
		last_scrolled_position = scrolled_container.position
