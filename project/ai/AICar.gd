extends BaseCar

func _ready():
	force = 20

func _physics_process(delta):
	update_movement()
	handle_shooting()

func update_movement():
	back_wheel.apply_torque_impulse(force)
	front_wheel.apply_torque_impulse(force)

func handle_shooting():
	for car in Global.car_refs:
		if car == self: continue
		var vector : Vector2 = car.global_position - global_position
		if abs(vector.angle_to(Vector2(1, 0).rotated(global_rotation))) < 0.1:
			if $BulletCooldown.time_left == 0:
				shoot()
