extends Control

onready var canvas = $VBoxContainer/Canvas
var scale = 1

func _ready():
	$Label.text = CarMaker.STATES_NAME[Global.car_maker.state]
	canvas.get_node("Outline").texture = load(CarMaker.STATES_IMAGES[Global.car_maker.state])
	canvas.get_node("Outline").rect_position -= canvas.get_node("Outline").texture.get_size() * scale/2
	canvas.get_node("Outline").rect_scale *= scale 

func _on_Clear_pressed():
	canvas.clear()


func _on_Accept_pressed():
	if Global.car_maker.state == CarMaker.States.CHASSIS:
		canvas.drawing_scale = .5
		Global.car_maker.convex_hull = canvas.get_convex_hull()
		Global.car_maker.outline = canvas.get_line()
		Global.car_maker.chassis_line = canvas.get_scaled_line()
		Global.car_maker.chassis_line.position -= canvas.rect_size / 2
		
		Global.car_maker.state = CarMaker.States.CHASSIS_DECO
		get_tree().change_scene("res://canvas/DecorationEditor.tscn")
	elif Global.car_maker.state == CarMaker.States.LEFT_WHEEL:
		canvas.drawing_scale = .3
		Global.car_maker.outline = canvas.get_line()
		Global.car_maker.left_wheel_hull = canvas.get_convex_hull()
		Global.car_maker.left_wheel_line = canvas.get_scaled_line()
		Global.car_maker.left_wheel_line.position -= canvas.rect_size / 2
		
		Global.car_maker.state = CarMaker.States.LEFT_WHEEL_DECO
		get_tree().change_scene("res://canvas/DecorationEditor.tscn")
	
	elif Global.car_maker.state == CarMaker.States.RIGHT_WHEEL:
		canvas.drawing_scale = .3
		Global.car_maker.outline = canvas.get_line()
		Global.car_maker.right_wheel_hull = canvas.get_convex_hull()
		Global.car_maker.right_wheel_line = canvas.get_scaled_line()
		Global.car_maker.right_wheel_line.position -= canvas.rect_size / 2
		
		Global.car_maker.state = CarMaker.States.RIGHT_WHEEL_DECO
		get_tree().change_scene("res://canvas/DecorationEditor.tscn")
	
	elif Global.car_maker.state == CarMaker.States.PROJECTILE:
		canvas.drawing_scale = .2
		Global.car_maker.projectile_hull = canvas.get_convex_hull()
		Global.car_maker.outline = canvas.get_line()
		Global.car_maker.projectile_line = canvas.get_scaled_line()
		Global.car_maker.projectile_line.position -= canvas.rect_size / 2
		
		Global.car_maker.state = CarMaker.States.PROJECTILE_DECO
		get_tree().change_scene("res://canvas/DecorationEditor.tscn")