extends Node2D

var id : int
var last_note := 0

func _ready():
	id = int(name.substr(3, 1)) - 1

func handle_track(elapsed_time : float, play_sequence : PoolVector3Array):
	for i in range(last_note, play_sequence.size()):
		var note = play_sequence[i]
		if note.x != id:
			continue
		if note.y <= elapsed_time and note.z > elapsed_time and not $AudioStreamPlayer.playing:
			last_note = i
			$AudioStreamPlayer.play()
		elif note.z <= elapsed_time and $AudioStreamPlayer.playing:
			last_note += 1
			$AudioStreamPlayer.stop()
