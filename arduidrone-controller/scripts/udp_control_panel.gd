@tool
extends ConnectedElement


func _on_destination_address_line_edit_text_submitted(new_text: String) -> void:
	var new_adress = new_text.split(":")
	UDP.set_dest_address(new_adress[0], int(new_adress[1]))


func _on_local_port_line_edit_text_submitted(new_text: String) -> void:
	UDP.stop_listening()
	UDP.listen(int(new_text))


func _on_poll_rate_line_edit_text_submitted(new_text: String) -> void:
	UDP.set_poll_rate(float(new_text))


func _on_output_traffic_check_button_toggled(toggled_on: bool) -> void:
	UDP.set_output_traffic(toggled_on)


func _on_ping_button_pressed() -> void:
	UDP.ping()
