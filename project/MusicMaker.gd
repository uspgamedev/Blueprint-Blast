extends Node2D

const MAJOR_SCALE = [0, 2, 4, 5, 7, 9, 11, 12]
const FACTOR = pow(2, 1.0/12)

var elapsed_time := 0.0
var play_sequence : PoolVector3Array
var start_time : float
var key_pressed := -1

func _ready():
	for i in range(get_children().size()):
		var key = get_children()[i]
		key.get_node("AudioStreamPlayer").pitch_scale *= pow(FACTOR, MAJOR_SCALE[i]) 

func _process(delta):
	elapsed_time += delta
	for i in range(get_children().size()):
		if Input.is_action_pressed(str("key_", i)) and key_pressed < 0:
			key_pressed = i 
			start_time = elapsed_time
			get_children()[i].get_node("AudioStreamPlayer").play()
		elif key_pressed == i and not Input.is_action_pressed(str("key_", i)):
			key_pressed = -1
			var vector = Vector3(i, start_time, elapsed_time)
			play_sequence.append(vector)
			get_children()[i].get_node("AudioStreamPlayer").stop()
