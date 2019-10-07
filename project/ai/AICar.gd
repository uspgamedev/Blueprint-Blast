extends BaseCar
class_name AICar

export var ai_acceleration = 250

const MAX_CRASH_TIME = 2

var crash_time = 0

func _ready():
	bullet_cooldown = 3
	$BulletCooldown.wait_time = bullet_cooldown
	acceleration = ai_acceleration
	for element in [self, front_wheel, back_wheel]:
		element.contact_monitor = true
		element.contacts_reported = 1
		
	$NitroCooldown.wait_time = 7
	load_car_maker(Global.car_makers[randi() % Global.car_makers.size()])

func _physics_process(delta):
	update_movement()
	handle_shooting()
	check_crash(delta)
	update_nitro()

func update_nitro():
	if Global.nitro_enabled and not $NitroParticles.emitting and $NitroCooldown.time_left == 0 and Global.race_state == Global.RACE_STATE.RACE:
		$NitroParticles.emitting = true
		applied_force = Vector2(2000, 0)
		$UI/Nitro.value = $UI/Nitro.max_value
		yield(get_tree().create_timer(NITRO_DURATION), "timeout")
		$NitroParticles.emitting = false
		applied_force = Vector2(0, 0)
		$NitroCooldown.start()

func update_movement():
	go_forward()

func handle_shooting():
	for car in Global.car_refs:
		if car == self: continue
		var vector : Vector2 = car.global_position - global_position
		if vector.length() > 2000:
			return
		if abs(vector.angle_to(Vector2(1, 0).rotated(global_rotation))) < 0.1:
			if $BulletCooldown.time_left == 0:
				shoot(null, $Cannon.global_position)

func check_crash(delta):
	if get_colliding_bodies().size() and not invincible and\
			not (front_wheel.get_colliding_bodies().size() or back_wheel.get_colliding_bodies().size()):
		crash_time += delta
	else:
		crash_time = 0
	
	if crash_time >= MAX_CRASH_TIME:
		crash_time = 0
		die()