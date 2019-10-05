extends Control

onready var canvas = $VBoxContainer/HBoxContainer2/DecorationCanvas

func _ready():
	pass


func _on_Undo_pressed():
	canvas.undo()


func _on_Clear_pressed():
	canvas.clear()


func _on_Accept_pressed():
	pass # Replace with function body.


func _on_ColorPicker_color_changed(color):
	canvas.change_color(color)


func _on_HSlider_value_changed(value):
	canvas.change_width(value)
	$VBoxContainer/HBoxContainer2/VBoxContainer2/LineWidth.text = str("Line Width: ", value)
