extends Control

onready var canvas = $VBoxContainer/PlacementCanvas

func _ready():
	$Label.text = CarMaker.STATES_NAME[CarMaker.state]
	canvas.get_node("Outline").texture = load(CarMaker.STATES_IMAGES[CarMaker.state])
	canvas.get_node("Outline").rect_position -= canvas.get_node("Outline").texture.get_size()/2
	
	if CarMaker.outline:
		canvas.add_child(CarMaker.outline)
	if CarMaker.outlines:
		for line in CarMaker.outlines:
			if line:
				var new_line = line.duplicate()
				new_line.position += rect_size/2
				canvas.add_child(new_line)


func _on_Accept_pressed():
	if CarMaker.state == CarMaker.States.PLACE_CANNON:
		CarMaker.cannon_position = canvas.get_pos()
		
		CarMaker.state = CarMaker.States.PROJECTILE
		get_tree().change_scene("res://canvas/Editor.tscn")
