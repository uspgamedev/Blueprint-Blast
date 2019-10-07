extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var i = 1
	for car_maker in Global.car_makers:
		i += 1
		var car = load("res://car/BaseCar.tscn").instance()
		car.load_car_maker(car_maker)
		var car_representation = load("res://canvas/CarRepresentation.tscn").instance()
		car_representation.get_node("CarPosition").add_child(car)
		car_representation.get_node("Button").connect("pressed", self, "_on_car_clicked", [i-2])
		$VBoxContainer/Cars/GridContainer.add_child(car_representation)

func _on_car_clicked(index):
	Global.car_maker = Global.car_makers[index]
	get_tree().change_scene("res://test/TestRaceWithAI.tscn")

func _on_AddButton_pressed():
	Global.design_mode = Global.DESIGN_MODE.GALLERY
	get_tree().change_scene("res://canvas/Editor.tscn")
