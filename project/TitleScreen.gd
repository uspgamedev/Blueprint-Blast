extends Control

func _ready():
	pass


func _on_NewGame_pressed():
	get_tree().change_scene("res://canvas/Editor.tscn")


func _on_Credits_pressed():
	get_tree().change_scene("res://CreditsScreen.tscn")
