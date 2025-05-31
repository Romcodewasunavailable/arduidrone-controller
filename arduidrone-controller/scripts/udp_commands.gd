extends RefCounted

signal output(message: String)

var udp_client: UDPClient


func set_poll_rate(rate_hz: float) -> void:
	udp_client.set_poll_rate(rate_hz)


func set_dest_address(ip: String = "", port: int = 0) -> void:
	udp_client.set_dest_address(ip, port)


func send(message: String) -> void:
	udp_client.send(message)


func listen(port: int) -> void:
	udp_client.listen(port)


func stop_listening() -> void:
	udp_client.stop_listening()


func _on_udp_client_system_output(message: String) -> void:
	output.emit(message)


func _on_udp_client_received(message: String, ip: String, port: int) -> void:
	output.emit("Received: %s" % message)


func _ready() -> void:
	udp_client = UDPClient.new()
	udp_client.connect("system_output", _on_udp_client_system_output)
	udp_client.connect("received", _on_udp_client_received)
	udp_client.listen(12345)
	udp_client.set_dest_address("192.168.1.6", 12345)


func _process(_delta: float) -> void:
	pass
