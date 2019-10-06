extends Node

var semaphore_counter := 0

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

