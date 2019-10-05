extends KinematicBody2D
class_name Bullet

const VELOCITY = 5
const DAMAGE = 20
const LIFETIME = 5

func _ready():
	$Lifetime.wait_time = LIFETIME
	$Lifetime.start()
	$Lifetime.connect("timeout", self, "obliterate")

func obliterate():
	queue_free()

func _physics_process(delta):
	var collision = move_and_collide(Vector2(1, 0).rotated(global_rotation) * VELOCITY)
	if collision != null:
		obliterate()
