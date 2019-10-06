extends Control

onready var canvas = $VBoxContainer/Canvas


func _ready():
	$Label.text = CarMaker.STATES_NAME[CarMaker.state]
	canvas.get_node("Outline").texture = load(CarMaker.STATES_IMAGES[CarMaker.state])
	canvas.get_node("Outline").rect_position -= canvas.get_node("Outline").texture.get_size() /2

func _on_Clear_pressed():
	canvas.clear()


func _on_Accept_pressed():
	if CarMaker.state == CarMaker.States.CHASSIS:
		canvas.drawing_scale = .5
		CarMaker.convex_hull = canvas.get_convex_hull()
		CarMaker.outline = canvas.get_line()
		CarMaker.chassis_line = canvas.get_scaled_line()
		CarMaker.chassis_line.position -= canvas.rect_size / 2
		
		CarMaker.state = CarMaker.States.CHASSIS_DECO
		get_tree().change_scene("res://canvas/DecorationEditor.tscn")
	elif CarMaker.state == CarMaker.States.LEFT_WHEEL:
		canvas.drawing_scale = .3
		CarMaker.outline = canvas.get_line()
		CarMaker.left_wheel_hull = canvas.get_convex_hull()
		CarMaker.left_wheel_line = canvas.get_scaled_line()
		CarMaker.left_wheel_line.position -= canvas.rect_size / 2
		
		CarMaker.state = CarMaker.States.LEFT_WHEEL_DECO
		get_tree().change_scene("res://canvas/DecorationEditor.tscn")
	
	elif CarMaker.state == CarMaker.States.RIGHT_WHEEL:
		canvas.drawing_scale = .3
		CarMaker.outline = canvas.get_line()
		CarMaker.right_wheel_hull = canvas.get_convex_hull()
		CarMaker.right_wheel_line = canvas.get_scaled_line()
		CarMaker.right_wheel_line.position -= canvas.rect_size / 2
		
		CarMaker.state = CarMaker.States.RIGHT_WHEEL_DECO
		get_tree().change_scene("res://canvas/DecorationEditor.tscn")
	
	elif CarMaker.state == CarMaker.States.PROJECTILE:
		canvas.drawing_scale = .2
		CarMaker.projectile_hull = canvas.get_convex_hull()
		CarMaker.outline = canvas.get_line()
		CarMaker.projectile_line = canvas.get_scaled_line()
		CarMaker.projectile_line.position -= canvas.rect_size / 2
		
		CarMaker.state = CarMaker.States.PROJECTILE_DECO
		get_tree().change_scene("res://canvas/DecorationEditor.tscn")