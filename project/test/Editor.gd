extends Control

onready var canvas = $VBoxContainer/Canvas

func _on_Clear_pressed():
	canvas.clear()


func _on_Accept_pressed():
	CarMaker.convex_hull = canvas.get_convex_hull()
	CarMaker.outline = canvas.line.duplicate()
	CarMaker.chassis_line = canvas.line.duplicate()
	CarMaker.chassis_line.position -= canvas.rect_size / 2
	
	get_tree().change_scene("res://test/DecorationEditor.tscn")
