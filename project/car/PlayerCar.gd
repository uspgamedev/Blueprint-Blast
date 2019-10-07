extends BaseCar
class_name PlayerCar

const AREA_TO_HP = .008
const ROTATION_FORCE = 400

func _ready():
	var main = get_parent()
	friction = 0.2
	$BulletCooldown.wait_time = bullet_cooldown
	if main.get("car_refs"):
		main.car_refs.append(self)
		
	load_car_maker(Global.car_maker)
		
	max_hp = area * AREA_TO_HP
	update_hp(max_hp)
	acceleration *= lerp(MAX_ACC_FACTOR, MIN_ACC_FACTOR, area / MAX_DRAW_AREA)
	update_wheel_acceleration()


func _physics_process(delta):
	update_movement_with_wheels()
	handle_shooting()


func _unhandled_input(event):
	if Global.race_state == Global.RACE_STATE.RACE:
		if event.is_action_pressed("reset") and not invincible:
			call_deferred("die")


func handle_shooting():
	if Input.is_action_just_pressed("shoot"):
		if $BulletCooldown.time_left == 0:
			shoot(bullet_info, $Cannon.global_position)
			$BulletCooldown.start()
			$BulletCooldown.start()

func update_movement_with_wheels():
	if Input.is_action_pressed("accelerate"):
		go_forward()
	if Input.is_action_pressed("reverse"):
		go_backward()

	var force = Vector2(0, 0)
	if Input.is_action_pressed("rotate_clockwise"):
		force += Vector2(0, 1).rotated(global_rotation)
	if Input.is_action_pressed("rotate_counter_clockwise"):
		force += Vector2(0, -1).rotated(global_rotation)
	back_wheel.applied_force = -force * ROTATION_FORCE
	front_wheel.applied_force = force * ROTATION_FORCE
