extends TextureButton

onready var label_pos = $Label.rect_position

const NORMAL_COLOR = Color("454545")
const PRESSED_COLOR = Color("a6a6a6")

func _ready():
	pass


func _on_TextureButton_button_down():
	$Label.rect_position.y = label_pos.y + 4
	$Label.set("custom_colors/font_color", PRESSED_COLOR)


func _on_TextureButton_button_up():
	$Label.rect_position = label_pos
	$Label.set("custom_colors/font_color", NORMAL_COLOR)
