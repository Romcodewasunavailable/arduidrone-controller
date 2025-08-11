extends Node

signal system_output(message: String)
signal received(object: Variant, ip: String, port: int)

const DEFAULT_DEST_IP = "192.168.50.69"
const DEFAULT_DEST_PORT = 12345
const DEFAULT_LOCAL_PORT = 12345

const PING_AMOUNT = 10
const PING_INTERVAL_MSEC = 500

var udp_client := UDPClient.new()
var ping_thread := Thread.new()

var ping_start_time: int
var ping_latencies := PackedInt32Array()


func set_poll_rate(rate_hz: float) -> void:
	udp_client.set_poll_rate(rate_hz)


func set_dest_address(ip: String = "", port: int = 0) -> void:
	udp_client.set_dest_address(ip, port)


func set_output_traffic(toggled_on: bool) -> void:
	udp_client.set_output_traffic(toggled_on)


func send(object: Variant) -> void:
	udp_client.send(object)


func listen(port: int) -> void:
	udp_client.listen(port)


func stop_listening() -> void:
	udp_client.stop_listening()


func ping() -> void:
	system_output.emit("Starting ping thread")
	if ping_thread.is_alive():
		system_output.emit("Ping thread already running")
		return
	elif ping_thread.is_started():
		ping_thread.wait_to_finish()
	ping_latencies.clear()
	ping_latencies.resize(PING_AMOUNT)
	ping_start_time = Time.get_ticks_msec()
	ping_thread.start(_ping_loop)


func _ping_loop() -> void:
	for i in range(PING_AMOUNT):
		udp_client.call_deferred("send", ["ping", i, Time.get_ticks_msec()])
		OS.delay_msec(PING_INTERVAL_MSEC)
	call_deferred("_process_pings")


func _process_pings() -> void:
	var total_received = 0
	var total_latency = 0
	for latency in ping_latencies:
		if latency == null or latency == 0:
			continue
		total_received += 1
		total_latency += latency
	if total_received == 0:
		system_output.emit("%d/%d pings returned" % [total_received, PING_AMOUNT])
	else:
		@warning_ignore("integer_division")
		system_output.emit("%d/%d pings returned, average latency: %d ms" % [total_received, PING_AMOUNT, total_latency / total_received])


func _on_udp_client_system_output(message: String) -> void:
	system_output.emit(message)


func _on_udp_client_received(object: Variant, ip: String, port: int) -> void:
	if object is Array and object[0] is String and object[0] == "ping":
		var ping_id = object[1]
		var ping_latency = Time.get_ticks_msec() - object[2]
		system_output.emit("Ping %d returned after %d ms" % [ping_id + 1, ping_latency])
		ping_latencies[ping_id] = ping_latency
	else:
		received.emit(object, ip, port)


func _ready() -> void:
	ping_latencies.resize(PING_AMOUNT)
	udp_client.system_output.connect(_on_udp_client_system_output)
	udp_client.received.connect(_on_udp_client_received)
	udp_client.call_deferred("listen", DEFAULT_LOCAL_PORT)
	udp_client.call_deferred("set_dest_address", DEFAULT_DEST_IP, DEFAULT_DEST_PORT)
