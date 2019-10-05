extends RigidBody2D
class_name BaseCar

const BULLET_PATH = "res://bullets/Bullet.tscn"

var max_velocity = 200
var acceleration = 100
var bullet_cooldown = .2
var front_wheel
var back_wheel

func _ready():
	friction = 0.2
	$BulletCooldown.wait_time = bullet_cooldown
	Global.car_refs.append(self)
