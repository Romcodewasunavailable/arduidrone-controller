@tool
class_name TitledConnectedElement
extends ConnectedElement

@export var title: String:
	set(value):
		title = value
		if is_node_ready():
			title_label.text = title

@export var title_label: Label


func _ready() -> void:
	super._ready()
	title_label.text = title
