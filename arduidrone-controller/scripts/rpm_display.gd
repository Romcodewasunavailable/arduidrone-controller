@tool
class_name RpmDisplay
extends ConnectedElement

@export var rpm: float:
	set(value):
		rpm = value
		if is_node_ready():
			update_display()
@export var max_rpm: float:
	set(value):
		max_rpm = value
		if is_node_ready():
			update_display()
@export var drone_axis := Drone.Axis.RPM_1

@export var rpm_gradient: Gradient
@export var texture_progress_bar: TextureProgressBar
@export var label: Label


func update_display():
	texture_progress_bar.value = rpm / max_rpm
	texture_progress_bar.tint_progress = rpm_gradient.sample(texture_progress_bar.value)
	label.text = "%d RPM" % roundi(rpm)


func update_rpm() -> void:
	rpm = Drone.axis_state[drone_axis]


func _ready() -> void:
	super._ready()
	update_display()
	if Engine.is_editor_hint():
		return

	update_rpm()
	Drone.state_updated.connect(update_rpm)
