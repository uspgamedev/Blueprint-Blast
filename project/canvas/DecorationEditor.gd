extends Control

onready var canvas = $VBoxContainer/HBoxContainer2/DecorationCanvas
var scale = 1

func _ready():
	$Label.text = CarMaker.STATES_NAME[CarMaker.state]
	canvas.get_node("Outline").texture = load(CarMaker.STATES_IMAGES[CarMaker.state])
	canvas.get_node("Outline").rect_position -= canvas.get_node("Outline").texture.get_size() * scale /2
	canvas.get_node("Outline").rect_scale *= scale
	if CarMaker.outline:
		canvas.add_child(CarMaker.outline)


func _on_Undo_pressed():
	canvas.undo()


func _on_Clear_pressed():
	canvas.clear()


func _on_Accept_pressed():
	if CarMaker.state == CarMaker.States.CHASSIS_DECO:
		canvas.drawing_scale = .5
		CarMaker.chassis_deco = canvas.get_scaled_lines()
		for line in CarMaker.chassis_deco:
			line.position -= canvas.rect_size / 2
			
		CarMaker.state = CarMaker.States.LEFT_WHEEL
		get_tree().change_scene("res://canvas/Editor.tscn")
		
	elif CarMaker.state == CarMaker.States.LEFT_WHEEL_DECO:
		canvas.drawing_scale = .3
		CarMaker.left_wheel_deco = canvas.get_scaled_lines()
		for line in CarMaker.left_wheel_deco:
			line.position -= canvas.rect_size / 2
		
		CarMaker.state = CarMaker.States.RIGHT_WHEEL
		get_tree().change_scene("res://canvas/Editor.tscn")
	
	elif CarMaker.state == CarMaker.States.RIGHT_WHEEL_DECO:
		canvas.drawing_scale = .3
		CarMaker.right_wheel_deco = canvas.get_scaled_lines()
		for line in CarMaker.right_wheel_deco:
			line.position -= canvas.rect_size / 2
		
		CarMaker.outline = null
		CarMaker.state = CarMaker.States.CANNON
		get_tree().change_scene("res://canvas/DecorationEditor.tscn")
		
	elif CarMaker.state == CarMaker.States.CANNON:
		canvas.drawing_scale = .3
		CarMaker.cannon = canvas.get_scaled_lines()
		for line in CarMaker.cannon:
			line.position -= canvas.rect_size / 2
			
		CarMaker.state = CarMaker.States.PROJECTILE
		get_tree().change_scene("res://canvas/Editor.tscn")
	
	elif CarMaker.state == CarMaker.States.PROJECTILE_DECO:
		canvas.drawing_scale = .3
		CarMaker.projectile_deco = canvas.get_scaled_lines()
		for line in CarMaker.projectile_deco:
			line.position -= canvas.rect_size / 2
			
		CarMaker.state = CarMaker.States.DONE
		get_tree().change_scene("res://test/TestRace.tscn")

func _on_ColorPicker_color_changed(color):
	canvas.change_color(color)


func _on_HSlider_value_changed(value):
	canvas.change_width(value)
	$VBoxContainer/HBoxContainer2/VBoxContainer2/LineWidth.text = str("Line Width: ", value)
