extends Node

enum RACE_STATE {START, RACE}

var race_state = RACE_STATE.START
var car_refs := []
var winners := []
var winner_list_gui

func add_winner(car):
	if not winners.has(car):
		winners.append(car)
		winner_list_gui._on_list_updated(winners)