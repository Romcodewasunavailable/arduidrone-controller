extends Node

signal system_output(message: String)
signal received(object: Variant, ip: String, port: int)

var udp_client: UDPClient


func set_poll_rate(rate_hz: float) -> void:
	udp_client.set_poll_rate(rate_hz)


func set_dest_address(ip: String = "", port: int = 0) -> void:
	udp_client.set_dest_address(ip, port)


func send(object: Variant) -> void:
	udp_client.send(object)


func listen(port: int) -> void:
	udp_client.listen(port)


func stop_listening() -> void:
	udp_client.stop_listening()


func _on_udp_client_system_output(message: String) -> void:
	system_output.emit(message)


func _on_udp_client_received(object: Variant, ip: String, port: int) -> void:
	received.emit(object, ip, port)


func _ready() -> void:
	udp_client = UDPClient.new()
	udp_client.connect("system_output", _on_udp_client_system_output)
	udp_client.connect("received", _on_udp_client_received)
	udp_client.call_deferred("listen", 12345)
	udp_client.call_deferred("set_dest_address", "192.168.1.6", 12345)
