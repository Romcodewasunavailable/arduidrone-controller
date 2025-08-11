@tool
extends ConnectedElement


func _on_precision_line_edit_text_submitted(new_text: String) -> void:
	Controller.set_precision(float(new_text))


func _on_deadzone_line_edit_text_submitted(new_text: String) -> void:
	Controller.set_deadzone(float(new_text))


func _on_poll_rate_line_edit_text_submitted(new_text: String) -> void:
	Controller.set_poll_rate(float(new_text))


func _on_send_udp_check_button_toggled(toggled_on: bool) -> void:
	Controller.set_send_udp(toggled_on)


func _on_pitch_p_line_edit_text_submitted(new_text):
	Controller.axis_state[Controller.Axis.PITCH_P] = float(new_text)


func _on_pitch_i_line_edit_text_submitted(new_text):
	Controller.axis_state[Controller.Axis.PITCH_I] = float(new_text)


func _on_pitch_d_line_edit_text_submitted(new_text):
	Controller.axis_state[Controller.Axis.PITCH_D] = float(new_text)
