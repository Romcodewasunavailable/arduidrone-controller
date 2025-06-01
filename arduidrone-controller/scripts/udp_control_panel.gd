@tool
extends ConnectedElement


func _on_destination_address_line_edit_text_submitted(new_text: String) -> void:
	var new_adress = new_text.split(":")
	UDP.set_dest_address(new_adress[0], int(new_adress[1]))


func _on_local_port_line_edit_text_submitted(new_text: String) -> void:
	UDP.stop_listening()
	UDP.listen(int(new_text))
