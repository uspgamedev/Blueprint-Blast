extends RigidBody2D
class_name PlayerCar

const BULLET_PATH = "res://bullets/Bullet.tscn"

const MAX_VELOCITY = 200
const ACCELERATION = 100
const BULLET_COOLDOWN = .2

onready var main = get_parent()

func _ready():
	friction = 0.2
	$BulletCooldown.wait_time = BULLET_COOLDOWN
	main.car_refs.append(self)

func _physics_process(delta):
	update_movement()
	handle_shooting()

func handle_shooting():
	if Input.is_action_just_pressed("shoot"):
		if $BulletCooldown.time_left == 0:
			var bullet = load(BULLET_PATH).instance()
			bullet.global_rotation = global_rotation
			bullet.add_collision_exception_with(self)
			bullet.global_position = global_position
			main.add_child(bullet)
			$BulletCooldown.start()

func update_movement():
	var vector := Vector2(0, 0)
	if Input.is_action_pressed("reverse"):
		vector += Vector2(-1, 0).rotated(global_rotation)
	if Input.is_action_pressed("accelerate"):
		vector += Vector2(1, 0).rotated(global_rotation)
	if Input.is_action_pressed("rotate_clockwise"):
		angular_velocity += 0.1
	if Input.is_action_pressed("rotate_counter_clockwise"):
		angular_velocity -= 0
	applied_force = vector.normalized() * ACCELERATION
	linear_velocity = linear_velocity.normalized() * min(linear_velocity.length(), MAX_VELOCITY)
