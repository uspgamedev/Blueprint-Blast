extends Button

var current_track
var is_recording = false

func _ready():
	connect("button_down", self, "button_press")

func button_press():
	current_track = get_parent().get_current_node_track()
	var track_name = current_track.name.substr(0, current_track.name.find("Music"))
	if not is_recording:
		is_recording = true
		text = str("Stop recording ", track_name, " track")
		current_track.start_recording()
		get_node("../FinishButton").hide()
	else:
		is_recording = false
		text = str("Start recording ", track_name, " track")
		current_track.stop_recording()
		if not current_track.is_base:
			var other_track = get_parent().get_other_track(current_track)
			other_track.elapsed_time = 0.0
			for key in other_track.get_children():
				key.last_note = 0
				key.get_node("AudioStreamPlayer").stop()
		get_node("../FinishButton").show()

