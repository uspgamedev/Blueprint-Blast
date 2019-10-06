extends RigidBody2D
class_name BaseCar

const BULLET_PATH := "res://bullets/Bullet.tscn"
const INVINCIBILITY_TIME := 3
const RESET_OFFSET := 200

var hp := 100
var acceleration := 300
var bullet_cooldown := 1
var invincible := false
onready var front_wheel = get_node("FrontWheel/SpinningBody")
onready var back_wheel = get_node("BackWheel/SpinningBody")

func _ready():
	friction = 0.2
	$BulletCooldown.wait_time = bullet_cooldown
	Global.car_refs.append(self)


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
		back_wheel.apply_torque_impulse(acceleration)
		front_wheel.apply_torque_impulse(acceleration)

func go_backward():
	if Global.race_state == Global.RACE_STATE.RACE:
		back_wheel.apply_torque_impulse(-acceleration)
		front_wheel.apply_torque_impulse(-acceleration)


func die():
	position.y -= RESET_OFFSET
	for element in [self, back_wheel, front_wheel]:
		element.global_rotation = 0
		element.linear_velocity = Vector2(0, 0)
		element.angular_velocity = 0
		element.applied_force = Vector2(0, 0)
		element.applied_torque = 0
	apply_invincibility()
	hp = 100


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
	hp -= damage
	if hp <= 0:
		die()
