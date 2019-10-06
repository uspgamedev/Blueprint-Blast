extends Control

onready var canvas = $VBoxContainer/HBoxContainer2/DecorationCanvas
var scale = 1

func _ready():
	$Label.text = CarMaker.STATES_NAME[Global.car_maker.state]
	canvas.get_node("Outline").texture = load(CarMaker.STATES_IMAGES[Global.car_maker.state])
	canvas.get_node("Outline").rect_position -= canvas.get_node("Outline").texture.get_size() * scale /2
	canvas.get_node("Outline").rect_scale *= scale
	if Global.car_maker.outline:
		canvas.add_child(Global.car_maker.outline)


func _on_Undo_pressed():
	canvas.undo()


func _on_Clear_pressed():
	canvas.clear()


func _on_Accept_pressed():
	if Global.car_maker.state == CarMaker.States.CHASSIS_DECO:
		canvas.drawing_scale = .5
		Global.car_maker.chassis_deco = canvas.get_scaled_lines()
		for line in Global.car_maker.chassis_deco:
			line.position -= canvas.rect_size / 2
			
		Global.car_maker.state = CarMaker.States.LEFT_WHEEL
		get_tree().change_scene("res://canvas/Editor.tscn")
		
	elif Global.car_maker.state == CarMaker.States.LEFT_WHEEL_DECO:
		canvas.drawing_scale = .3
		Global.car_maker.left_wheel_deco = canvas.get_scaled_lines()
		for line in Global.car_maker.left_wheel_deco:
			line.position -= canvas.rect_size / 2
		
		Global.car_maker.state = CarMaker.States.RIGHT_WHEEL
		get_tree().change_scene("res://canvas/Editor.tscn")
	
	elif Global.car_maker.state == CarMaker.States.RIGHT_WHEEL_DECO:
		canvas.drawing_scale = .3
		Global.car_maker.right_wheel_deco = canvas.get_scaled_lines()
		for line in Global.car_maker.right_wheel_deco:
			line.position -= canvas.rect_size / 2
		
		Global.car_maker.outline = null
		Global.car_maker.state = CarMaker.States.CANNON
		get_tree().change_scene("res://canvas/DecorationEditor.tscn")
		
	elif Global.car_maker.state == CarMaker.States.CANNON:
		canvas.drawing_scale = .3
		Global.car_maker.cannon = canvas.get_scaled_lines()
		for line in Global.car_maker.cannon:
			line.position -= canvas.rect_size / 2
			
		Global.car_maker.state = CarMaker.States.PROJECTILE
		get_tree().change_scene("res://canvas/Editor.tscn")
	
	elif Global.car_maker.state == CarMaker.States.PROJECTILE_DECO:
		canvas.drawing_scale = .3
		Global.car_maker.projectile_deco = canvas.get_scaled_lines()
		for line in Global.car_maker.projectile_deco:
			line.position -= canvas.rect_size / 2
			
		Global.car_maker.state = CarMaker.States.DONE
		get_tree().change_scene("res://test/TestRaceWithAI.tscn")

func _on_ColorPicker_color_changed(color):
	canvas.change_color(color)


func _on_HSlider_value_changed(value):
	canvas.change_width(value)
	$VBoxContainer/HBoxContainer2/VBoxContainer2/LineWidth.text = str("Line Width: ", value)
