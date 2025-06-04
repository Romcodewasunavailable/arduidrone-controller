class_name UDPClient
extends RefCounted

signal system_output(message: String)
signal received(object: Variant, ip: String, port: int)

var _poll_delay_msec := 10
var _dest_ip := ""
var _dest_port := 0

var _udp := PacketPeerUDP.new()
var _thread := Thread.new()
var _thread_running := false


func set_poll_rate(rate_hz: float) -> void:
	_poll_delay_msec = roundi(1000.0 / rate_hz)


func set_dest_address(ip: String = "", port: int = 0) -> void:
	if ip == "":
		ip = _dest_ip
	if port == 0:
		port = _dest_port

	system_output.emit("Setting destination address to %s:%d" % [ip, port])
	var err = _udp.set_dest_address(ip, port)
	if err != OK:
		system_output.emit("Failed to set destination address: %s" % error_string(err))
		return
	_dest_ip = ip
	_dest_port = port


func send(object: Variant) -> void:
	system_output.emit("Sending: %s" % str(object))
	if _dest_ip == "" or _dest_port == 0:
		system_output.emit("Destination address not set")
		return
	var result = Messagepack.encode(object)
	if result.status != OK:
		system_output.emit("Failed to encode messagepack: %s" % error_string(result.status))
		return
	_udp.put_packet(result.value)


func listen(port: int) -> void:
	system_output.emit("Binding UDP socket to port: %d" % port)
	var err = _udp.bind(port)
	if err != OK:
		system_output.emit("Failed to bind UDP socket: %s" % error_string(err))
		return

	system_output.emit("Starting listener thread")
	if _thread_running:
		system_output.emit("Listener thread already running")
		return
	_thread_running = true
	_thread.start(_listener_loop)


func stop_listening() -> void:
	system_output.emit("Exiting listener thread")
	_thread_running = false
	if _thread.is_started():
		_thread.wait_to_finish()

	system_output.emit("Closing UDP socket")
	_udp.close()


func _listener_loop() -> void:
	while _thread_running:
		while _udp.get_available_packet_count() > 0:
			var data = _udp.get_packet()
			var ip = _udp.get_packet_ip()
			var port = _udp.get_packet_port()
			var result = Messagepack.decode(data)
			if result.status != OK:
				call_deferred("emit_signal", "system_output", "Failed to decode messagepack: %s" % error_string(result.status))
			else:
				call_deferred("emit_signal", "received", result.value, ip, port)
		OS.delay_msec(_poll_delay_msec)
