extends Node

var semaphore_counter := 0

func _ready():
	if Global.race_instructions and has_node("Instructions"):
		$Instructions.show()
		$Instructions/Label.text = Global.race_instructions
	elif $Instructions:
		$Instructions.hide()

func _on_SemaphoreTimer_timeout():
	semaphore_counter += 1
	match semaphore_counter:
		2:
			show_semaphore($HUD/Semaphore/light1, Color.red)
			$HUD/Semaphore/RedBeep.play()
		3: 
			show_semaphore($HUD/Semaphore/light2, Color.red)
			$HUD/Semaphore/RedBeep.play()
		4:
			show_semaphore($HUD/Semaphore/light3, Color.red)
			$HUD/Semaphore/RedBeep.play()
		5:
			show_semaphore($HUD/Semaphore/light4, Color.green)
			$HUD/Semaphore/GreenBeep.play()
			Global.race_state = Global.RACE_STATE.RACE
		7:
			hide_semaphore($HUD/Semaphore/light1, 0)
			hide_semaphore($HUD/Semaphore/light2, .08)
			hide_semaphore($HUD/Semaphore/light3, .16)
			hide_semaphore($HUD/Semaphore/light4, .24)

func show_semaphore(sema, color):
	sema.modulate = color
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(sema, "rect_position:y", null, sema.rect_position.y + 100, .5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	tween.queue_free()

func hide_semaphore(sema, delay):
	yield(get_tree().create_timer(delay), "timeout")
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(sema, "rect_position:y", null, sema.rect_position.y - 100, .5, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	tween.queue_free()


func _on_GoalArea2D_area_entered(area):
	var car = area.get_parent()
	if car is BaseCar:
		Global.add_winner(car)
		if car is PlayerCar:
			yield(get_tree().create_timer(1), "timeout")
			Global.race_state = Global.RACE_STATE.START
			Global.car_refs.clear()
			Global.winners.clear()
			match Global.car_maker.state:
				CarMaker.States.CHASSIS_DECO:
					get_tree().change_scene("res://canvas/DecorationEditor.tscn")
				CarMaker.States.CANNON:
					get_tree().change_scene("res://canvas/DecorationEditor.tscn")
				CarMaker.States.MUSIC:
					get_tree().change_scene("res://music/Piano.tscn")
				CarMaker.States.GALLERY:
					if Global.add_player_car:
						Global.add_player_car = false
						Global.car_makers.append(Global.car_maker)
					get_tree().change_scene("res://canvas/Gallery.tscn")

