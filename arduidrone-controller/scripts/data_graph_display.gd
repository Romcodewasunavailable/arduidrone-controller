@tool
class_name DataGraphDisplay
extends GraphDisplay

@export var data_display: DataDisplay:
	set(value):
		if data_display != null:
			data_display.data_updated.disconnect(update_data)
		data_display = value
		if data_display != null:
			data_display.data_updated.connect(update_data)
		update_data()


func update_data() -> void:
	if data_display == null:
		values.clear()
	else:
		values.resize(keys.size())
		for i in range(keys.size()):
			if data_display.keys.has(keys[i]):
				var value_index = data_display.keys.find(keys[i])
				if value_index >= 0 and value_index < data_display.values.size():
					values[i] = float(data_display.values[value_index])
					continue
			values[i] = 0.0
