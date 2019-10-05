extends RigidBody2D

func _ready():
	friction = 0.2

func _physics_process(delta):
	update_movement()

func update_movement():
	var vector := Vector2(0, 0)
	if Input.is_action_pressed("reverse"):
		vector += Vector2(-1, 0)
	if Input.is_action_pressed("accelerate"):
		vector += Vector2(1, 0)
	if Input.is_action_pressed("rotate_clockwise"):
		angular_velocity += 0.1
	if Input.is_action_pressed("rotate_counter_clockwise"):
		angular_velocity -= 0.1
	applied_force = vector.normalized() * 100
	linear_velocity = linear_velocity.normalized() * min(linear_velocity.length(), 200)
