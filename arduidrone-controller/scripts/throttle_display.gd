@tool
class_name ThrottleDisplay
extends ConnectedElement

@export var throttle: float:
	set(value):
		throttle = value
		if is_node_ready():
			update_display()
@export var min_throttle: float:
	set(value):
		min_throttle = value
		if is_node_ready():
			update_display()
@export var max_throttle: float:
	set(value):
		max_throttle = value
		if is_node_ready():
			update_display()
@export var key := Drone.Axis.THROTTLE_1

@export var rpm_gradient: Gradient
@export var texture_progress_bar: TextureProgressBar
@export var label: Label


func update_display():
	texture_progress_bar.value = (throttle - min_throttle) / (max_throttle - min_throttle)
	texture_progress_bar.tint_progress = rpm_gradient.sample(texture_progress_bar.value)
	label.text = "%d μs" % roundi(throttle)


func update_throttle() -> void:
	throttle = Drone.axis_state[key]


func _ready() -> void:
	super._ready()
	update_display()
	if Engine.is_editor_hint():
		return

	update_throttle()
	Drone.state_updated.connect(update_throttle)
