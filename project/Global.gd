extends Node

# This was created as an enum because I planned 3 states, now that it has 2 it can be a bool
enum RACE_STATE {START, RACE} 

enum DESIGN_MODE {INITIAL, GALLERY}

var design_mode = DESIGN_MODE.INITIAL
var race_state = RACE_STATE.START
var car_refs := []
var winners := []
var winner_list_gui
var terrain_difficulty := 8 # 1-8
var terrain_length := 10000
var shooting_enabled := true
var canvas_offset : = Vector2(300, 238)
var add_player_car := false
var race_instructions = null

var car_makers := []
var line_2d_references := []

onready var car_maker : CarMaker = CarMaker.new()

func _ready():
	if car_makers.empty():
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
				car_makers.append(new_car_maker)
		
		dir.list_dir_end()

func add_winner(car):
	if not winners.has(car):
		winners.append(car)
		winner_list_gui._on_list_updated(winners)