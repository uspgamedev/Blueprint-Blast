extends BaseCar
class_name PlayerCar

const AREA_TO_HP = .008
const ROTATION_FORCE = 400

onready var engine_start : AudioStreamPlayer2D = $EngineStart
var original_pitch
var original_volume

func _ready():
	var main = get_parent()
	friction = 0.2
	$BulletCooldown.wait_time = bullet_cooldown
	
	load_car_maker(Global.car_maker)
	
	max_hp = area * AREA_TO_HP
	update_hp(max_hp)
	acceleration *= lerp(MAX_ACC_FACTOR, MIN_ACC_FACTOR, area / MAX_DRAW_AREA)
	update_wheel_acceleration()
	motor_sfx.play()
	original_pitch = clamp(lerp(3, .9, area/25000), .9, 3)
	engine_start.pitch_scale = clamp(lerp(4, 1.5, area/25000), 1.5, 4)
	motor_sfx.pitch_scale = original_pitch
	original_volume = 0.67/(original_pitch * original_pitch) # Stevens's power law
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(motor_sfx, "volume_db", -80, -10, 2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	tween.queue_free()

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
		motor_sfx.volume_db = lerp(motor_sfx.volume_db, original_volume, .01)
		motor_sfx.pitch_scale = lerp(motor_sfx.pitch_scale, original_pitch * 1.5, .01)
		go_forward()
	elif Input.is_action_pressed("reverse"):
		motor_sfx.volume_db = lerp(motor_sfx.volume_db, original_volume, .01)
		motor_sfx.pitch_scale = lerp(motor_sfx.pitch_scale, original_pitch * 1.5, .01)
		go_backward()
	else:
		motor_sfx.volume_db = lerp(motor_sfx.volume_db, -5, .1)
		motor_sfx.pitch_scale = lerp(motor_sfx.pitch_scale, original_pitch, .1)
		

	var force = Vector2(0, 0)
	if Input.is_action_pressed("rotate_clockwise"):
		force += Vector2(0, 1).rotated(global_rotation)
	if Input.is_action_pressed("rotate_counter_clockwise"):
		force += Vector2(0, -1).rotated(global_rotation)
	back_wheel.applied_force = -force * ROTATION_FORCE
	front_wheel.applied_force = force * ROTATION_FORCE
	
	applied_force.rotated(rotation)

func _input(event):
	if not $NitroParticles.emitting and $NitroCooldown.time_left == 0 and event.is_action_pressed("nitro") and Global.race_state == Global.RACE_STATE.RACE and Global.nitro_enabled:
		$NitroParticles.emitting = true
		applied_force = Vector2(2000, 0)
		$UI/Nitro.value = $UI/Nitro.max_value
		yield(get_tree().create_timer(NITRO_DURATION), "timeout")
		$NitroParticles.emitting = false
		applied_force = Vector2(0, 0)
		$NitroCooldown.start()
