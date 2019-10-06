extends RigidBody2D
class_name BaseCar

const BULLET_PATH := "res://bullets/Bullet.tscn"
const INVINCIBILITY_TIME := 3
const RESET_OFFSET := 200
const MAX_DRAW_AREA = 71400
const MAX_ACC_FACTOR = 2.0
const MIN_ACC_FACTOR = .5

var back_wheel_area
var front_wheel_area
var hp := 100
var max_hp := 100
var acceleration := 300
var back_acceleration
var front_acceleration
var bullet_cooldown := 1
var invincible := false
onready var front_wheel = $FrontWheel/SpinningBody
onready var back_wheel = $BackWheel/SpinningBody

func _ready():
	friction = 0.2
	$BulletCooldown.wait_time = bullet_cooldown
	Global.car_refs.append(self)
	update_wheel_acceleration()

func update_wheel_acceleration():
	back_wheel_area = ConvexPolygonArea.get_convex_polygon_area(back_wheel.get_node("Polygon2D").polygon)
	front_wheel_area = ConvexPolygonArea.get_convex_polygon_area(front_wheel.get_node("Polygon2D").polygon)
	back_acceleration = lerp(60, acceleration, min(back_wheel_area, 2000)/2000)
	front_acceleration = lerp(60, acceleration, min(front_wheel_area, 2000)/2000)

func update_hp(value):
	hp = value
	$HP.value = lerp(0, 100, value/max_hp)

func shoot(bullet_info, pos):
	if Global.race_state == Global.RACE_STATE.RACE:
		var bullet = load(BULLET_PATH).instance()
		bullet.global_rotation = global_rotation
		bullet.add_collision_exception_with(self)
		bullet.add_collision_exception_with(front_wheel)
		bullet.add_collision_exception_with(back_wheel)
		if pos:
			bullet.global_position = pos
		else:
			bullet.global_position = global_position
		if bullet_info:
			bullet.add_child(bullet_info["line"].duplicate())
			for line in bullet_info["deco"]:
				if (line):
					bullet.add_child(line.duplicate())
			bullet.get_node("CollisionPolygon2D").polygon = bullet_info["hull"]
		Global.add_child(bullet)
		$BulletCooldown.start()


func go_forward():
	if Global.race_state == Global.RACE_STATE.RACE:
		back_wheel.apply_torque_impulse(back_acceleration)
		front_wheel.apply_torque_impulse(front_acceleration)


func go_backward():
	if Global.race_state == Global.RACE_STATE.RACE:
		back_wheel.apply_torque_impulse(-back_acceleration)
		front_wheel.apply_torque_impulse(-front_acceleration)


func die():
	position.y -= RESET_OFFSET
	for element in [self, back_wheel, front_wheel]:
		element.global_rotation = 0
		element.linear_velocity = Vector2(0, 0)
		element.angular_velocity = 0
		element.applied_force = Vector2(0, 0)
		element.applied_torque = 0
	apply_invincibility()
	update_hp(max_hp)


func apply_invincibility():
	if invincible:
		return

	invincible = true

	# Blinking animation
	var blink_times = 4
	var duration = INVINCIBILITY_TIME / (blink_times * 2.0)
	var tween = Tween.new()
	add_child(tween)

	for i in range(blink_times):
		tween.interpolate_property(self, "modulate:a", null, 0,
			duration, Tween.TRANS_LINEAR, Tween.EASE_IN, duration * i * 2)
		tween.interpolate_property(self, "modulate:a", null, 1,
			duration, Tween.TRANS_LINEAR, Tween.EASE_IN, duration * (i * 2 + 1))
	tween.start()

	yield(get_tree().create_timer(INVINCIBILITY_TIME), "timeout")

	tween.queue_free()
	invincible = false


func apply_damage(damage : float):
	if not invincible:
		update_hp(hp - damage)
		if hp <= 0:
			die()
