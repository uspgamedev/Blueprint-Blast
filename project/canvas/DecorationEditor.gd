extends Control

onready var canvas = $VBoxContainer/HBoxContainer2/DecorationCanvas

func _ready():
	$Label.text = CarMaker.STATES_NAME[CarMaker.state]
	canvas.get_node("Outline").texture = load(CarMaker.STATES_IMAGES[CarMaker.state])
	canvas.get_node("Outline").rect_position -= canvas.get_node("Outline").texture.get_size()/2
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
		
		CarMaker.outline = CarMaker.chassis_line
		CarMaker.outlines = []
		for line in CarMaker.chassis_deco:
			var new_line = line.duplicate()
			new_line.position += canvas.rect_size/2
			var center = rect_size/2
			for i in range(new_line.get_point_count()):
				var point = new_line.points[i]
				new_line.set_point_position(i, center + (point - center)/.5)
			CarMaker.outlines.append(line.duplicate())
		
		CarMaker.placing_object = CarMaker.cannon
		
		CarMaker.state = CarMaker.States.PLACE_CANNON
		get_tree().change_scene("res://canvas/PlacementEditor.tscn")
	
	elif CarMaker.state == CarMaker.States.PROJECTILE_DECO:
		canvas.drawing_scale = .3
		CarMaker.projectile_deco = canvas.get_scaled_lines()
		for line in CarMaker.projectile_deco:
			line.position -= canvas.rect_size / 2
			
		CarMaker.state = CarMaker.States.DONE
		get_tree().change_scene("res://test/TestRaceWithAI.tscn")

func _on_ColorPicker_color_changed(color):
	canvas.change_color(color)


func _on_HSlider_value_changed(value):
	canvas.change_width(value)
	$VBoxContainer/HBoxContainer2/VBoxContainer2/LineWidth.text = str("Line Width: ", value)
