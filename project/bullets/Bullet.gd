extends RigidBody2D
class_name Bullet

const VELOCITY = 300
const DAMAGE = 20
const LIFETIME = 5
const EXPLOSION_FORCE = 150
const RADIUS = 60

var shooter

func _ready():
	$Lifetime.wait_time = LIFETIME
	$Lifetime.start()
	$Lifetime.connect("timeout", self, "obliterate")
	linear_velocity = Vector2(1, 0).rotated(global_rotation) * VELOCITY

func obliterate():
	queue_free()

func explode():
	for car in Global.car_refs:
		var vector : Vector2 = car.global_position - global_position
		var magnitude : float = clamp(inverse_lerp(RADIUS, 0, vector.length()), 0, 1)
		var impulse : float = lerp(0, EXPLOSION_FORCE, magnitude)
		car.apply_impulse(Vector2(0, 0), vector.normalized() * impulse)
		randomize()
		car.angular_velocity += vector.normalized().x * impulse/20
	obliterate()


func _on_Bullet_body_entered(body):
	if body != shooter:
		explode()
