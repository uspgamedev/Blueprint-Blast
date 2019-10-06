extends RigidBody2D
class_name Bullet

enum {MIN, MAX}

onready var area = ConvexPolygonArea.get_convex_polygon_area($CollisionPolygon2D.polygon)
onready var area_ratio = area / MAX_AREA

const VELOCITY := 1000
const DAMAGE := 20
const LIFETIME := 5
const IMPULSE_FORCE := 200
const ROTATION_FORCE = 2
const RADIUS := 400
const VELOCITY_FACTOR := [1.5, 0.2]
const DAMAGE_FACTOR := [.8, 10]
const MAX_AREA = 11425

func _ready():
	printt("area", area)
	printt("area_ratio", area_ratio)
	$Lifetime.wait_time = LIFETIME
	$Lifetime.start()
	$Lifetime.connect("timeout", self, "queue_free")
	linear_velocity = Vector2(1, 0).rotated(global_rotation) * VELOCITY *\
		lerp(VELOCITY_FACTOR[MIN], VELOCITY_FACTOR[MAX], area_ratio)

func explode():
	for car in Global.car_refs:
		var vector : Vector2 = car.global_position - global_position
		var magnitude : float = clamp(inverse_lerp(RADIUS, 0, vector.length()), 0, 1)
		var impulse : float = lerp(0, IMPULSE_FORCE, magnitude)
		car.apply_impulse(Vector2(0, 0), vector.normalized() * impulse)
		randomize()
		car.back_wheel.apply_impulse(Vector2(0, 0), -vector.normalized().rotated(PI/2) * impulse * ROTATION_FORCE)
		car.front_wheel.apply_impulse(Vector2(0, 0), vector.normalized().rotated(PI/2) * impulse * ROTATION_FORCE)
		var damage = inverse_lerp(0, IMPULSE_FORCE, impulse) * DAMAGE *\
			 lerp(DAMAGE_FACTOR[MIN], DAMAGE_FACTOR[MAX], area_ratio)
		car.apply_damage(damage)
	queue_free()

# warning-ignore:unused_argument
func _on_Bullet_body_entered(body):
	explode()
