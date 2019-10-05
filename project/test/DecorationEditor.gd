extends Control

onready var canvas = $VBoxContainer/HBoxContainer2/DecorationCanvas

func _ready():
	$Label.text = CarMaker.STATES_NAME[CarMaker.state]
	if CarMaker.outline:
		canvas.add_child(CarMaker.outline)


func _on_Undo_pressed():
	canvas.undo()


func _on_Clear_pressed():
	canvas.clear()


func _on_Accept_pressed():
	if CarMaker.state == CarMaker.States.CHASSIS_DECO:
		CarMaker.state = CarMaker.States.LEFT_WHEEL
		CarMaker.chassis_deco = []
		for line in canvas.lines:
			var new_line = line.duplicate()
			new_line.position -= canvas.rect_size / 2
			CarMaker.chassis_deco.append(new_line)
		get_tree().change_scene("res://test/Editor.tscn")


func _on_ColorPicker_color_changed(color):
	canvas.change_color(color)


func _on_HSlider_value_changed(value):
	canvas.change_width(value)
	$VBoxContainer/HBoxContainer2/VBoxContainer2/LineWidth.text = str("Line Width: ", value)
