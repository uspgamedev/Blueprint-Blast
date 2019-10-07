extends Control

func _ready():
	var i = 1
	for car_maker in Global.car_makers:
		i += 1
		var car = load("res://car/BaseCar.tscn").instance()
		car.load_car_maker(car_maker)
		var car_representation = load("res://canvas/CarRepresentation.tscn").instance()
		car_representation.get_node("CarPosition").add_child(car)
		car_representation.get_node("Button").connect("pressed", self, "_on_car_clicked", [i-2])
		$Cars/GridContainer.add_child(car_representation)

func _on_car_clicked(index):
	Global.car_maker = Global.car_makers[index]
	Global.car_maker.state = CarMaker.States.GALLERY
	Global.terrain_difficulty = 8
	Global.terrain_length = 10000
	Global.shooting_enabled = true
	Global.race_instructions = null
	Global.car_refs = []
	get_tree().change_scene("res://test/TestRaceWithAI.tscn")

func _on_AddButton_pressed():
	Global.design_mode = Global.DESIGN_MODE.GALLERY
	get_tree().change_scene("res://canvas/Editor.tscn")
