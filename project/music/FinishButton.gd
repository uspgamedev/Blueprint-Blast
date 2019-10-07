extends Button

onready var Piano = get_parent()

func _ready():
	connect("button_down", self, "button_down")

func button_down():
	var current_track = Piano.get_current_node_track()
	if current_track.name == "BaseMusicMaker":
		Piano.switch_current_track()
		Piano.get_node("RecordButton").text = "Start recording melody track"
		current_track = Piano.get_current_node_track()
		text = "Finish Melody Track"
	else:
		Piano.get_parent().remove_child(Piano)
		Global.add_child(Piano)
		Piano.hide()
		Global.terrain_difficulty = 8
		Global.terrain_length = 8000
		Global.shooting_enabled = true
		Global.nitro_enabled = true
		Global.car_maker.state = Global.car_maker.States.GALLERY
		Global.add_player_car = true
		Global.race_instructions = null
		get_tree().change_scene("res://test/TestRaceWithAI.tscn")