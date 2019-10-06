extends Node2D

export (bool) var is_base

const MAJOR_SCALE = [0, 2, 4, 5, 7, 9, 11, 12]
const NOTE_DISTANCE = [0, 2, 3, 5, 7, 9, 10]
const FACTOR = pow(2, 1.0/12)
const VOLUMES = [0, -1.25, -2.5]

var elapsed_time := 0.0
var play_sequence : PoolVector3Array
var volume_sequence : PoolVector2Array
var last_note
var start_time : float
var song_duration : float
var key_pressed := []
var is_recording := false
var current_notes := {}
var is_active = false

func _ready():
	update_pitch(0)

func update_pitch(offset):
	var base_offset = 0
	if is_base:
		base_offset = -12
	for i in range(get_children().size()):
		var key = get_children()[i]
		key.get_node("AudioStreamPlayer").pitch_scale = pow(FACTOR, MAJOR_SCALE[i] + NOTE_DISTANCE[offset] + base_offset) 

func _process(delta):
	if is_recording and is_active:
		record_song(delta)
	else:
		play_custom_song(delta)

func stop_recording():
	if not is_recording:
		return
	is_recording = false
	for key in get_children():
		key.last_note = 0
	if is_base:
		if play_sequence.size() > 0:
			song_duration = elapsed_time
		else:
			song_duration = 0
	else:
		var base = get_parent().get_other_track(self)
		song_duration = base.song_duration * ceil(elapsed_time / base.song_duration)
	elapsed_time = 0
	
func start_recording():
	if is_recording:
		return
	if not is_base:
		var base = get_parent().get_other_track(self)
		base.elapsed_time = 0.0
		for key in base.get_children():
			key.get_node("AudioStreamPlayer").stop()
			key.last_note = 0
	for key in get_children():
		key.get_node("AudioStreamPlayer").stop()
	elapsed_time = 0
	is_recording = true
	play_sequence = PoolVector3Array([])

func record_song(delta):
	elapsed_time += delta
	for i in range(get_children().size()):
		var audio_stream = get_children()[i].get_node("AudioStreamPlayer")
		if key_pressed.find(i) == -1 and Input.is_action_pressed(str("key_", i+1)) and key_pressed.size() < 3:
			current_notes[i] = Vector3(i, elapsed_time, -1)
			if not audio_stream.playing:
				audio_stream.play()
				key_pressed.append(i)
				volume_sequence.append(Vector2(elapsed_time, key_pressed.size()))
				for audio_index in key_pressed:
					var aud = get_children()[audio_index].get_node("AudioStreamPlayer")
					aud.volume_db = VOLUMES[key_pressed.size()-1]
		elif key_pressed.find(i) != -1 and not Input.is_action_pressed(str("key_", i+1)):
			current_notes[i].z = elapsed_time
			play_sequence.append(current_notes[i])
			current_notes.erase(i)
			if audio_stream.playing:
				audio_stream.stop()
				key_pressed.erase(i)
				volume_sequence.append(Vector2(elapsed_time, key_pressed.size()))
				for audio_index in key_pressed:
					var aud = get_children()[audio_index].get_node("AudioStreamPlayer")
					aud.volume_db = VOLUMES[key_pressed.size()-1]

func play_custom_song(delta):
	elapsed_time += delta
	var cur_volume = 0
	for volume in volume_sequence:
		if volume.x <= elapsed_time:
			cur_volume = volume.y
	for key in get_children():
		key.handle_track(elapsed_time, play_sequence, VOLUMES[cur_volume-1])
	if elapsed_time >= song_duration:
		elapsed_time = 0
		for key in get_children():
			key.last_note = 0
		