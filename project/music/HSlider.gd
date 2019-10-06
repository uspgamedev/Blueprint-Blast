extends HSlider

onready var audio_stream = $AudioStreamPlayer
onready var label = $Label
onready var button = $Button
var bpm : float = 60.0
var elapsed_time := 0.0
var is_playing := false

func _ready():
	button.connect("button_down", self, "button_press")
	connect("value_changed", self, "update_bpm")

func button_press():
	if not is_playing:
		button.text = "Stop"
		elapsed_time = 60.0/bpm
		is_playing = true
	else:
		button.text = "Start"
		is_playing = false

func _process(delta):
	if is_playing:
		elapsed_time += delta
		if elapsed_time >= 60.0/bpm:
			elapsed_time -= 60.0/bpm
			audio_stream.play()

func update_bpm(value):
	bpm = float(value)
	label.text = str("BPM: ", value)