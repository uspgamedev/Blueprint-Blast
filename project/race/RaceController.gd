extends Node

var semaphore_counter := 0

func _on_SemaphoreTimer_timeout():
	semaphore_counter += 1
	match semaphore_counter:
		2:
			$Semaphore/light1.modulate = Color.red
		3: 
			$Semaphore/light2.modulate = Color.red
		4:
			$Semaphore/light3.modulate = Color.red
		5:
			$Semaphore/light4.modulate = Color.green
			Global.race_state = Global.RACE_STATE.RACE
		7:
			$Semaphore.hide()