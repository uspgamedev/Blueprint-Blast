extends Node2D

const MAJOR_SCALE = [0, 2, 4, 5, 7, 9, 11, 12]
const FACTOR = pow(2, 1.0/12)

var elapsed_time := 0.0
var play_sequence : PoolVector3Array
var last_note
var start_time : float
var song_duration : float
var key_pressed := -1
var is_recording := true

func _ready():
	for i in range(get_children().size()):
		var key = get_children()[i]
		key.get_node("AudioStreamPlayer").pitch_scale *= pow(FACTOR, MAJOR_SCALE[i]) 

func _input(event):
	if event.is_action_pressed("accelerate"):
		start_recording()
	elif event.is_action_pressed("reverse"):
		stop_recording()
		
func _process(delta):
	if is_recording:
		record_song(delta)
	else:
		play_custom_song(delta)

func stop_recording():
	elapsed_time = 0
	is_recording = false
	last_note = 0
	if play_sequence.size() > 0:
		song_duration = play_sequence[-1].z
	else:
		song_duration = 0

func start_recording():
	for key in get_children():
		key.get_node("AudioStreamPlayer").stop()
	elapsed_time = 0
	is_recording = true
	play_sequence = PoolVector3Array([])

func record_song(delta):
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

func play_custom_song(delta):
	elapsed_time += delta
	for i in range(last_note, play_sequence.size()):
		var note = play_sequence[i]
		if note.y <= elapsed_time and note.z > elapsed_time and not get_children()[note.x].get_node("AudioStreamPlayer").playing:
			last_note = i
			get_children()[note.x].get_node("AudioStreamPlayer").play()
		elif note.z < elapsed_time and get_children()[note.x].get_node("AudioStreamPlayer").playing:
			last_note += 1
			get_children()[note.x].get_node("AudioStreamPlayer").stop()
	if elapsed_time > song_duration:
		elapsed_time = 0
		last_note = 0
		