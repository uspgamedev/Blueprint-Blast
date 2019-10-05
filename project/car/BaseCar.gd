extends RigidBody2D
class_name BaseCar

const BULLET_PATH = "res://bullets/Bullet.tscn"

var force = 40
var max_velocity = 200
var acceleration = 100
var bullet_cooldown = .2
onready var front_wheel = $FrontWheel
onready var back_wheel = $BackWheel

func _ready():
	friction = 0.2
	$BulletCooldown.wait_time = bullet_cooldown
	Global.car_refs.append(self)
