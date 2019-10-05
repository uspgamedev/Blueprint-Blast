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
		canvas.drawing_scale = .3
		CarMaker.chassis_deco = canvas.get_scaled_lines()
		for line in CarMaker.chassis_deco:
			line.position -= canvas.rect_size / 2
			
		CarMaker.state = CarMaker.States.LEFT_WHEEL
		get_tree().change_scene("res://canvas/Editor.tscn")


func _on_ColorPicker_color_changed(color):
	canvas.change_color(color)


func _on_HSlider_value_changed(value):
	canvas.change_width(value)
	$VBoxContainer/HBoxContainer2/VBoxContainer2/LineWidth.text = str("Line Width: ", value)
