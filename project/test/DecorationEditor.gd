extends Control

func _ready():
	pass


func _on_Undo_pressed():
	$VBoxContainer/HBoxContainer2/DecorationCanvas.undo()


func _on_Clear_pressed():
	$VBoxContainer/HBoxContainer2/DecorationCanvas.clear()


func _on_Accept_pressed():
	pass # Replace with function body.
