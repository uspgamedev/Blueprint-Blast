extends Node2D

const duration = 0.7
const onomatopoeias = ["BOOM!!", "KABOOM!!", "BANG!!", "POW!!", "BLAM!!",
		"KAPOW!!", "BADABOOM!!", "PLOP!!"]

func _ready():
	$AudioStreamPlayer2D.play()
	$AudioStreamPlayer2D.pitch_scale += randf()*2
	randomize()
	rotation_degrees = rand_range(-20, 20)
	$Label.text = onomatopoeias[randi() % onomatopoeias.size()]
	$Label.rect_rotation = rand_range(-20, 20) - rotation_degrees
	
	var tween = $Tween
	tween.interpolate_property(self, "modulate:a", 1, 0, duration,
			Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()
	
	yield(tween, "tween_completed")
	yield($AudioStreamPlayer2D, "finished")
	
	queue_free()
