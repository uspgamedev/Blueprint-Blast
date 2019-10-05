extends Control

onready var canvas = $VBoxContainer/Canvas

func _ready():
	$Label.text = CarMaker.STATES_NAME[CarMaker.state]

func _on_Clear_pressed():
	canvas.clear()


func _on_Accept_pressed():
	if CarMaker.state == CarMaker.States.CHASSIS:
		CarMaker.convex_hull = canvas.get_convex_hull()
		CarMaker.outline = canvas.line.duplicate()
		CarMaker.chassis_line = canvas.line.duplicate()
		CarMaker.chassis_line.position -= canvas.rect_size / 2
		
		CarMaker.state = CarMaker.States.CHASSIS_DECO
		get_tree().change_scene("res://test/DecorationEditor.tscn")
	elif CarMaker.state == CarMaker.States.LEFT_WHEEL:
		CarMaker.left_wheel_hull = canvas.get_convex_hull()
		CarMaker.left_wheel_line = canvas.line.duplicate()
		CarMaker.left_wheel_line.position -= canvas.rect_size / 2
		
		CarMaker.state = CarMaker.States.RIGHT_WHEEL
		get_tree().change_scene("res://test/Editor.tscn")
	
	elif CarMaker.state == CarMaker.States.RIGHT_WHEEL:
		CarMaker.right_wheel_hull = canvas.get_convex_hull()
		CarMaker.right_wheel_line = canvas.line.duplicate()
		CarMaker.right_wheel_line.position -= canvas.rect_size / 2
		
		CarMaker.state = CarMaker.States.DONE
		get_tree().change_scene("res://test/TestRace.tscn")