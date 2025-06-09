@tool
class_name RpmDisplay
extends ConnectedElement

@export var propeller: int
@export var max_rpm: float:
	set(value):
		max_rpm = value
		update_display()

@export var rpm: float:
	set(value):
		rpm = value
		update_display()

@export var rpm_gradient: Gradient
@export var texture_progress_bar: TextureProgressBar
@export var label: Label


func update_display():
	if texture_progress_bar == null or label == null:
		return

	texture_progress_bar.value = rpm / max_rpm
	texture_progress_bar.tint_progress = rpm_gradient.sample(texture_progress_bar.value)
	label.text = "%d RPM" % roundi(rpm)


func _on_udp_received(object: Variant, ip: String, port: int) -> void:
	#rpm = object[0][propeller]
	pass


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	UDP.connect("received", _on_udp_received)
