extends RigidBody2D
class_name BaseCar

const BULLET_PATH = "res://bullets/Bullet.tscn"

var force = 200
var max_velocity = 200
var acceleration = 100
var bullet_cooldown = .2
onready var front_wheel = get_node("FrontWheel/SpinningBody")
onready var back_wheel = get_node("BackWheel/SpinningBody")

func _ready():
	friction = 0.2
	$BulletCooldown.wait_time = bullet_cooldown
	Global.car_refs.append(self)

func shoot():
	if Global.race_state == Global.RACE_STATE.RACE:
		var bullet = load(BULLET_PATH).instance()
		bullet.global_rotation = global_rotation
		bullet.add_collision_exception_with(self)
		bullet.add_collision_exception_with(front_wheel)
		bullet.add_collision_exception_with(back_wheel)
		bullet.global_position = global_position
		Global.add_child(bullet)
		$BulletCooldown.start()

func go_forward():
	if Global.race_state == Global.RACE_STATE.RACE:
		back_wheel.apply_torque_impulse(force)
		front_wheel.apply_torque_impulse(force)
	
func go_backward():
	if Global.race_state == Global.RACE_STATE.RACE:
		back_wheel.apply_torque_impulse(-force)
		front_wheel.apply_torque_impulse(-force)
	
