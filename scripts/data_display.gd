@tool
class_name DataDisplay
extends LineConnector

@export var data: Array[Array] = [["key", 1.0]]

var last_data: Array[Array]


func update_data():
	pass


func _process(_delta):
	if data != last_data:
		update_data()
		last_data = data
