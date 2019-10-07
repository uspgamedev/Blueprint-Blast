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

var car_makers := []
var line_2d_references := []

onready var car_maker : CarMaker = CarMaker.new()

func add_winner(car):
	if not winners.has(car):
		winners.append(car)
		winner_list_gui._on_list_updated(winners)