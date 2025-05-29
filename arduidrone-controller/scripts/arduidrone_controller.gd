extends Control

var udp_client = UDPClient.new()


func _on_udp_client_received(message: String, ip: String, port: int) -> void:
	print("Received from %s:%d -> %s" % [ip, port, message])


func _ready() -> void:
	udp_client.connect("received", _on_udp_client_received)
	udp_client.listen(12345)
	udp_client.set_dest_address("192.168.1.6", 12345)
	udp_client.send("Hello myself, this is myself !")


func _process(_delta: float) -> void:
	pass
