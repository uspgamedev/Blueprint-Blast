extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.car_makers.empty():
		var dir = Directory.new()
		dir.open("res://cars")
		dir.list_dir_begin()
		
		while true:
			var file = dir.get_next()
			if file == "":
				break
			elif not file.begins_with("."):
				var new_car_maker = CarMaker.new()
				var new_car_maker_file = File.new()
				new_car_maker_file.open("res://cars/" + file, File.READ)
				new_car_maker.load_from_string(new_car_maker_file)
				new_car_maker_file.close()
				Global.car_makers.append(new_car_maker)
		
		dir.list_dir_end()
		
	
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
