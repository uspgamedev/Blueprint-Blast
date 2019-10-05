extends BaseCar
class_name PlayerCar

func _ready():
	
	var main = get_parent()
#	front_wheel = $FrontWheel
#	back_wheel = $BackWheel
	friction = 0.2
	$BulletCooldown.wait_time = bullet_cooldown
	if main.get("car_refs"):
		main.car_refs.append(self)
	if CarMaker.state == CarMaker.States.DONE:
		$CollisionShape2D.shape.points = CarMaker.convex_hull
		add_child(CarMaker.chassis_line)
		for line in CarMaker.chassis_deco:
			if (line):
				add_child(line)
#		back_wheel.set_wheel_polygon(CarMaker.left_wheel_line.points)
#		front_wheel.set_wheel_polygon(CarMaker.right_wheel_line.points)

func _physics_process(delta):
	update_movement_with_wheels()
	handle_shooting()


func handle_shooting():
	if Input.is_action_just_pressed("shoot"):
		if $BulletCooldown.time_left == 0:
			shoot()

func update_movement():
	var vector := Vector2(0, 0)
	if Input.is_action_pressed("reverse"):
		vector += Vector2(-1, 0).rotated(global_rotation)
	if Input.is_action_pressed("accelerate"):
		vector += Vector2(1, 0).rotated(global_rotation)
	if Input.is_action_pressed("rotate_clockwise"):
		angular_velocity += 0.1
	if Input.is_action_pressed("rotate_counter_clockwise"):
		angular_velocity -= 0.1
	applied_force = vector.normalized() * acceleration
	linear_velocity = linear_velocity.normalized() * min(linear_velocity.length(), max_velocity)

func update_movement_with_wheels():
	if Input.is_action_pressed("accelerate"):
		back_wheel.apply_torque_impulse(force)
		front_wheel.apply_torque_impulse(force)
	if Input.is_action_pressed("reverse"):
		back_wheel.apply_torque_impulse(-force)
		front_wheel.apply_torque_impulse(-force)

	if Input.is_action_pressed("rotate_clockwise"):
		angular_velocity += 0.1
	if Input.is_action_pressed("rotate_counter_clockwise"):
		angular_velocity -= 0
