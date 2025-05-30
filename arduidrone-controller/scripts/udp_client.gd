class_name UDPClient
extends RefCounted

signal received(message: String, ip: String, port: int)

var _poll_delay_msec := 10
var _dest_ip := ""
var _dest_port := 0

var _udp := PacketPeerUDP.new()
var _thread := Thread.new()
var _thread_running := false


func set_poll_rate(rate_hz: float) -> void:
	_poll_delay_msec = 1000.0 / rate_hz


func set_dest_address(ip: String, port: int) -> void:
	print("Setting destination adress to %s:%d" % [ip, port])
	_dest_ip = ip
	_dest_port = port
	_udp.set_dest_address(ip, port)


func send(message: String) -> void:
	print("Sending: %s" % message)
	if _dest_ip == "" or _dest_port == 0:
		push_error("Destination address not set")
		return
	_udp.put_packet(message.to_utf8_buffer())


func listen(port: int) -> void:
	print("Listening on port: %d" % port)
	var err = _udp.bind(port)
	if err != OK:
		push_error("Failed to bind UDP socket: %s" % err)
		return
	if _thread_running:
		push_warning("Listener thread already running")
		return
	print("Starting listener thread")
	_thread_running = true
	_thread.start(_listener_loop)


func stop_listening() -> void:
	print("Exiting listener thread")
	_thread_running = false
	if _thread.is_started():
		_thread.wait_to_finish()


func _listener_loop() -> void:
	while _thread_running:
		while _udp.get_available_packet_count() > 0:
			var data = _udp.get_packet()
			var ip = _udp.get_packet_ip()
			var port = _udp.get_packet_port()
			var message = data.get_string_from_utf8()
			call_deferred("emit_signal", "received", message, ip, port)
		OS.delay_msec(_poll_delay_msec)
