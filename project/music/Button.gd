extends Button

var music_maker
var id : int

func _ready():
	id = int(name.substr(6, 1))
	connect("button_down", self, "change_offset")

func change_offset():
	music_maker = get_node("../../../").get_current_node_track()
	music_maker.update_pitch(id - 1)
