extends RigidBody2D
class_name Bullet

enum {MIN, MAX}

onready var area = ConvexPolygonArea.get_convex_polygon_area($CollisionPolygon2D.polygon)
onready var area_ratio = area / MAX_AREA

const VELOCITY := 600
const DAMAGE := 20
const LIFETIME := 5
const IMPULSE_FORCE := 200
const ROTATION_FORCE = 2
const RADIUS := 400
const VELOCITY_FACTOR := [1.4, 0.02]
const DAMAGE_FACTOR := [.5, 10]
const MAX_AREA = 11425

func _ready():
	$Lifetime.wait_time = LIFETIME
	$Lifetime.start()
	$Lifetime.connect("timeout", self, "destroy")
	linear_velocity = Vector2(1, 0).rotated(global_rotation) * VELOCITY *\
		lerp(VELOCITY_FACTOR[MIN], VELOCITY_FACTOR[MAX], area_ratio)
	
func _exit_tree():
	var particles = $Particles2D
	var particles_position = position
	remove_child(particles)
	get_parent().add_child(particles)
	particles.emitting = false
	particles.global_position = particles_position
	
	var explosion = load("res://bullets/Explosion.tscn").instance()
	explosion.position = position
	get_parent().add_child(explosion)
	
func explode():
	for car in Global.car_refs:
		var vector : Vector2 = car.global_position - global_position
		var magnitude : float = clamp(inverse_lerp(RADIUS, 0, vector.length()), 0, 1)
		var impulse : float = lerp(0, IMPULSE_FORCE, magnitude)
		car.apply_impulse(Vector2(0, 0), vector.normalized() * impulse)
		randomize()
#		car.back_wheel.apply_impulse(Vector2(0, 0), -vector.normalized().rotated(PI/2) * impulse * ROTATION_FORCE)
#		car.front_wheel.apply_impulse(Vector2(0, 0), vector.normalized().rotated(PI/2) * impulse * ROTATION_FORCE)
		var damage = inverse_lerp(0, IMPULSE_FORCE, impulse) * DAMAGE *\
			 lerp(DAMAGE_FACTOR[MIN], DAMAGE_FACTOR[MAX], area_ratio)
		car.apply_damage(damage)
		
	destroy()
	
	
func destroy():
	queue_free()

# warning-ignore:unused_argument
func _on_Bullet_body_entered(body):
	explode()
