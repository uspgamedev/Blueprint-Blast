extends Button

onready var Piano = get_parent()

func _ready():
	connect("button_down", self, "button_down")

func button_down():
	var current_track = Piano.get_current_node_track()
	if current_track.name == "BaseMusicMaker":
		Piano.switch_current_track()
		self.hide()
		Piano.get_node("RecordButton").text = "Start recording melody track"
		current_track = Piano.get_current_node_track()