extends Control

onready var base_node_track = $BaseMusicMaker
onready var melody_node_track = $MelodyMusicMaker
var current_track

func _ready():
	current_track = base_node_track
	base_node_track.is_active = true

func get_current_node_track():
	return current_track
