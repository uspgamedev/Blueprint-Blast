extends Node

enum RACE_STATE {START, RACE}

var race_state = RACE_STATE.START
var car_refs := []
var winners := []
var winner_list_gui
var terrain_difficulty := 8 # 1-8

onready var car_maker : CarMaker = CarMaker.new()

func add_winner(car):
	if not winners.has(car):
		winners.append(car)
		winner_list_gui._on_list_updated(winners)