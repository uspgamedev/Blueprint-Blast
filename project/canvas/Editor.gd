extends Control

onready var canvas = $HBox/Canvas
var scale = 1

func _ready():
	if Global.design_mode == Global.DESIGN_MODE.GALLERY:
		$Label.text = CarMaker.STATES_NAME[Global.car_maker.state]
	else:
		$Label.text = CarMaker.STORY_NAME[Global.car_maker.state]
	canvas.get_node("Outline").texture = load(CarMaker.STATES_IMAGES[Global.car_maker.state])
	canvas.get_node("Outline").rect_position -= canvas.get_node("Outline").texture.get_size() * scale/2
	canvas.get_node("Outline").rect_scale *= scale 

func _on_Clear_pressed():
	canvas.clear()


func _on_Accept_pressed():
	Global.canvas_offset = canvas.rect_size / 2
	if Global.car_maker.state == CarMaker.States.CHASSIS:
		canvas.drawing_scale = .5
		Global.car_maker.convex_hull = canvas.get_convex_hull()
		Global.car_maker.outline = canvas.get_line()
		Global.car_maker.chassis_outline = canvas.get_line()
		Global.car_maker.chassis_line_points = canvas.get_scaled_line().points
		
		if Global.design_mode == Global.DESIGN_MODE.GALLERY:
			Global.car_maker.state = CarMaker.States.CHASSIS_DECO
			get_tree().change_scene("res://canvas/DecorationEditor.tscn")
		else:
			Global.car_maker.state = CarMaker.States.LEFT_WHEEL
			get_tree().change_scene("res://canvas/Editor.tscn")
	elif Global.car_maker.state == CarMaker.States.LEFT_WHEEL:
		canvas.drawing_scale = .3
		Global.car_maker.outline = canvas.get_line()
		Global.car_maker.left_wheel_outline = canvas.get_line()
		Global.car_maker.left_wheel_hull = canvas.get_convex_hull()
		Global.car_maker.left_wheel_line_points = canvas.get_scaled_line().points
		
		
		if Global.design_mode == Global.DESIGN_MODE.GALLERY:
			Global.car_maker.state = CarMaker.States.LEFT_WHEEL_DECO
			get_tree().change_scene("res://canvas/DecorationEditor.tscn")
		else:
			Global.car_maker.state = CarMaker.States.RIGHT_WHEEL
			get_tree().change_scene("res://canvas/Editor.tscn")
	
	elif Global.car_maker.state == CarMaker.States.RIGHT_WHEEL:
		canvas.drawing_scale = .3
		Global.car_maker.outline = canvas.get_line()
		Global.car_maker.right_wheel_outline = canvas.get_line()
		Global.car_maker.right_wheel_hull = canvas.get_convex_hull()
		Global.car_maker.right_wheel_line_points = canvas.get_scaled_line().points
		
		if Global.design_mode == Global.DESIGN_MODE.GALLERY:
			Global.car_maker.state = CarMaker.States.RIGHT_WHEEL_DECO
			get_tree().change_scene("res://canvas/DecorationEditor.tscn")
		else:
			Global.car_maker.state = CarMaker.States.CHASSIS_DECO
			Global.terrain_difficulty = 1
			Global.terrain_length = 3000
			Global.shooting_enabled = false
			Global.car_maker.outline = Global.car_maker.chassis_outline
			Global.nitro_enabled = false
			Global.race_instructions = "Accelerate: D\nReverse: A\nRotate Car: W and S\nReset Car: R"
			get_tree().change_scene("res://test/TestRaceWithAI.tscn")
	
	elif Global.car_maker.state == CarMaker.States.PROJECTILE:
		canvas.drawing_scale = .2
		Global.car_maker.projectile_hull = canvas.get_convex_hull()
		Global.car_maker.outline = canvas.get_line()
		Global.car_maker.projectile_line_points = canvas.get_scaled_line().points
		
		Global.car_maker.state = CarMaker.States.PROJECTILE_DECO
		get_tree().change_scene("res://canvas/DecorationEditor.tscn")