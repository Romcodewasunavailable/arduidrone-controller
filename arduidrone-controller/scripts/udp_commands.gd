extends Commands


func set_poll_rate(rate_hz: float) -> void:
	UDP.set_poll_rate(rate_hz)


func set_dest_address(ip: String = "", port: int = 0) -> void:
	UDP.set_dest_address(ip, port)


func set_output_traffic(toggled_on: bool) -> void:
	UDP.set_output_traffic(toggled_on)


func send(object: Variant) -> void:
	UDP.send(object)


func listen(port: int) -> void:
	UDP.listen(port)


func stop_listening() -> void:
	UDP.stop_listening()


func ping() -> void:
	UDP.ping()


func _on_udp_system_output(message: String) -> void:
	output.emit(message)


func _ready() -> void:
	UDP.system_output.connect(_on_udp_system_output)
