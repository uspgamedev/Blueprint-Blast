extends Node

var semaphore_counter := 0

func _ready():
	Global.car_refs = []

func _on_SemaphoreTimer_timeout():
	semaphore_counter += 1
	match semaphore_counter:
		2:
			$HUD/Semaphore/light1.modulate = Color.red
		3: 
			$HUD/Semaphore/light2.modulate = Color.red
		4:
			$HUD/Semaphore/light3.modulate = Color.red
		5:
			$HUD/Semaphore/light4.modulate = Color.green
			Global.race_state = Global.RACE_STATE.RACE
		7:
			$HUD/Semaphore.hide()

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
					Global.car_maker.state = CarMaker.States.GALLERY
					get_tree().change_scene("res://canvas/Gallery.tscn")
#					get_tree().change_scene("res://canvas/DecorationEditor.tscn")
				CarMaker.States.CANNON:
					get_tree().change_scene("res://canvas/DecorationEditor.tscn")
				CarMaker.States.MUSIC:
					get_tree().change_scene("res://music/Piano.tscn")
				CarMaker.States.GALLERY:
					get_tree().change_scene("res://canvas/Gallery.tscn")

