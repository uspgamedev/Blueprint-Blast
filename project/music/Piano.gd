extends Control

var last_button : Button = null

func _ready():
	for button in $VBoxContainer/HBoxContainer.get_children():
		button.connect("button_down", self, "disable_last_button")

func disable_last_button():
	if last_button:
		last_button.pressed = false