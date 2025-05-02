extends Node3D

var left_joystick = Vector2.ZERO
var right_joystick = Vector2.ZERO

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	left_joystick = Vector2(Input.get_axis("yaw_left", "yaw_right"), Input.get_axis("thrust_down", "thrust_up"))
	right_joystick = Vector2(Input.get_axis("roll_left", "roll_right"), Input.get_axis("pitch_up", "pitch_down"))
	$UI/LeftJoystick/Joystick.position = Vector2(left_joystick.x * 25 - 37.5, -left_joystick.y * 25 - 37.5)
	$UI/RightJoystick/Joystick.position = Vector2(right_joystick.x * 25 - 37.5, -right_joystick.y * 25 - 37.5)
