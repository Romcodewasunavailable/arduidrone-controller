@tool
extends DataDisplay

enum AXES {YAW, PITCH, ROLL}


func _on_udp_received(object: Variant, ip: String, port: int) -> void:
	#values = object[1]
	pass


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	keys = AXES.keys()
	UDP.connect("received", _on_udp_received)
