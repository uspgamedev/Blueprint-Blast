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
		for line in canvas.get_scaled_lines():
			Global.car_maker.chassis_deco.append(line.points)
			Global.car_maker.chassis_deco_color.append(line.default_color)
			Global.car_maker.chassis_deco_width.append(line.width)
		
		if Global.design_mode == Global.DESIGN_MODE.GALLERY:
			Global.car_maker.state = CarMaker.States.LEFT_WHEEL
			get_tree().change_scene("res://canvas/Editor.tscn")
		else:
			Global.car_maker.state = CarMaker.States.LEFT_WHEEL_DECO
			Global.car_maker.outline = Global.car_maker.left_wheel_outline
			get_tree().change_scene("res://canvas/DecorationEditor.tscn")
		
	elif Global.car_maker.state == CarMaker.States.LEFT_WHEEL_DECO:
		canvas.drawing_scale = .3
		for line in canvas.get_scaled_lines():
			Global.car_maker.left_wheel_deco.append(line.points)
			Global.car_maker.left_wheel_deco_color.append(line.default_color)
			Global.car_maker.left_wheel_deco_width.append(line.width)
		
		if Global.design_mode == Global.DESIGN_MODE.GALLERY:
			Global.car_maker.state = CarMaker.States.RIGHT_WHEEL
			get_tree().change_scene("res://canvas/Editor.tscn")
		else:
			Global.car_maker.state = CarMaker.States.RIGHT_WHEEL_DECO
			Global.car_maker.outline = Global.car_maker.right_wheel_outline
			get_tree().change_scene("res://canvas/DecorationEditor.tscn")
	
	elif Global.car_maker.state == CarMaker.States.RIGHT_WHEEL_DECO:
		canvas.drawing_scale = .3
		for line in canvas.get_scaled_lines():
			Global.car_maker.right_wheel_deco.append(line.points)
			Global.car_maker.right_wheel_deco_color.append(line.default_color)
			Global.car_maker.right_wheel_deco_width.append(line.width)
		
		Global.car_maker.outline = null
		
		if Global.design_mode == Global.DESIGN_MODE.GALLERY:
			Global.car_maker.state = CarMaker.States.CANNON
			get_tree().change_scene("res://canvas/DecorationEditor.tscn")
		else:
			Global.car_maker.state = CarMaker.States.CANNON
			Global.terrain_difficulty = 3
			Global.terrain_length = 4000
			Global.shooting_enabled = false
			get_tree().change_scene("res://test/TestRaceWithAI.tscn")
		
	elif Global.car_maker.state == CarMaker.States.CANNON:
		canvas.drawing_scale = .3
		for line in canvas.get_scaled_lines():
			Global.car_maker.cannon_deco.append(line.points)
			Global.car_maker.cannon_color.append(line.default_color)
			Global.car_maker.cannon_width.append(line.width)
			
		Global.car_maker.state = CarMaker.States.PROJECTILE
		get_tree().change_scene("res://canvas/Editor.tscn")
	
	elif Global.car_maker.state == CarMaker.States.PROJECTILE_DECO:
		canvas.drawing_scale = .3
		for line in canvas.get_scaled_lines():
			Global.car_maker.projectile_deco.append(line.points)
			Global.car_maker.projectile_deco_color.append(line.default_color)
			Global.car_maker.projectile_deco_width.append(line.width)
			
		
		match Global.design_mode:
			Global.DESIGN_MODE.INITIAL:
				Global.terrain_difficulty = 5
				Global.terrain_length = 5000
				Global.shooting_enabled = true
				Global.car_maker.state = CarMaker.States.MUSIC
				get_tree().change_scene("res://test/TestRaceWithAI.tscn")
			Global.DESIGN_MODE.GALLERY:
				Global.car_makers.append(Global.car_maker)
				
				var save_game = File.new()
				save_game.open("user://" + str(OS.get_unix_time()) + ".car", File.WRITE)
				for attribute in Global.car_maker.get_property_list():
					if Global.car_maker.get(attribute.name):
						save_game.store_line(attribute.name)
						save_game.store_line(str(Global.car_maker.get(attribute.name)))
				save_game.close()
				
				Global.car_maker = CarMaker.new()
				get_tree().change_scene("res://canvas/Gallery.tscn")

func _on_ColorPicker_color_changed(color):
	canvas.change_color(color)


func _on_HSlider_value_changed(value):
	canvas.change_width(value)
	$VBoxContainer/HBoxContainer2/VBoxContainer2/LineWidth.text = str("Line Width: ", value)
