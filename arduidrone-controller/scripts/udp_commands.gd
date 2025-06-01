extends RefCounted

signal output(message: String)


func set_poll_rate(rate_hz: float) -> void:
	UDP.set_poll_rate(rate_hz)


func set_dest_address(ip: String = "", port: int = 0) -> void:
	UDP.set_dest_address(ip, port)


func send(object: Variant) -> void:
	UDP.send(object)


func listen(port: int) -> void:
	UDP.listen(port)


func stop_listening() -> void:
	UDP.stop_listening()


func _on_udp_system_output(message: String) -> void:
	output.emit(message)


func _on_udp_received(object: Variant, ip: String, port: int) -> void:
	output.emit("Received: %s" % str(object))


func _ready() -> void:
	UDP.connect("system_output", _on_udp_system_output)
	UDP.connect("received", _on_udp_received)


func _process(_delta: float) -> void:
	pass
