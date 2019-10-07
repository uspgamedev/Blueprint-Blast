extends RigidBody2D
class_name BaseCar

const BULLET_PATH := "res://bullets/Bullet.tscn"
const INVINCIBILITY_TIME := 3
const RESET_OFFSET := 200
const MAX_DRAW_AREA = 71400
const MAX_ACC_FACTOR = 2.0
const MIN_ACC_FACTOR = .5

var back_wheel_area
var front_wheel_area
var hp := 100
var max_hp := 100
var acceleration := 300
var back_acceleration
var front_acceleration
var bullet_cooldown := 1
var invincible := false
var bullet_info = {}
var area : float

onready var front_wheel = get_node("FrontWheel/SpinningBody")
onready var back_wheel = get_node("BackWheel/SpinningBody")

func _ready():
	friction = 0.2
	$BulletCooldown.wait_time = bullet_cooldown
	Global.car_refs.append(self)
	update_wheel_acceleration()

func update_wheel_acceleration():
	back_wheel_area = ConvexPolygonArea.get_convex_polygon_area(back_wheel.get_node("Polygon2D").polygon)
	front_wheel_area = ConvexPolygonArea.get_convex_polygon_area(front_wheel.get_node("Polygon2D").polygon)
	back_acceleration = lerp(60, acceleration, min(back_wheel_area, 2000)/2000)
	front_acceleration = lerp(60, acceleration, min(front_wheel_area, 2000)/2000)

func update_hp(value):
	hp = value
	$HP.value = lerp(0, 100, value/max_hp)

func shoot(bullet_info, pos):
	if Global.race_state == Global.RACE_STATE.RACE:
		var bullet = load(BULLET_PATH).instance()
		bullet.global_rotation = global_rotation
		bullet.add_collision_exception_with(self)
		bullet.add_collision_exception_with(front_wheel)
		bullet.add_collision_exception_with(back_wheel)
		if pos:
			bullet.global_position = pos
		else:
			bullet.global_position = global_position
		if bullet_info:
			bullet.add_child(get_line2d(bullet_info["line"]))
			
			for i in range(bullet_info["deco"].size()):
				if (bullet_info["deco"][i]):
					bullet.add_child(get_line2d(bullet_info["deco"][i], bullet_info["deco_color"][i], bullet_info["deco_width"][i]))

			bullet.get_node("CollisionPolygon2D").polygon = bullet_info["hull"]
		get_parent().add_child(bullet)
		$BulletCooldown.start()


func go_forward():
	if Global.race_state == Global.RACE_STATE.RACE:
		back_wheel.apply_torque_impulse(back_acceleration)
		front_wheel.apply_torque_impulse(front_acceleration)


func go_backward():
	if Global.race_state == Global.RACE_STATE.RACE:
		back_wheel.apply_torque_impulse(-back_acceleration)
		front_wheel.apply_torque_impulse(-front_acceleration)


func die():
	position.y -= RESET_OFFSET
	for element in [self, back_wheel, front_wheel]:
		element.global_rotation = 0
		element.linear_velocity = Vector2(0, 0)
		element.angular_velocity = 0
		element.applied_force = Vector2(0, 0)
		element.applied_torque = 0
	apply_invincibility()
	update_hp(max_hp)


func apply_invincibility():
	if invincible:
		return

	invincible = true

	# Blinking animation
	var blink_times = 4
	var duration = INVINCIBILITY_TIME / (blink_times * 2.0)
	var tween = Tween.new()
	add_child(tween)

	for i in range(blink_times):
		tween.interpolate_property(self, "modulate:a", null, 0,
			duration, Tween.TRANS_LINEAR, Tween.EASE_IN, duration * i * 2)
		tween.interpolate_property(self, "modulate:a", null, 1,
			duration, Tween.TRANS_LINEAR, Tween.EASE_IN, duration * (i * 2 + 1))
	tween.start()

	yield(get_tree().create_timer(INVINCIBILITY_TIME), "timeout")

	tween.queue_free()
	invincible = false


func apply_damage(damage : float):
	if not invincible:
		update_hp(hp - damage)
		if hp <= 0:
			die()
	

func load_car_maker(car_maker: CarMaker):
	if car_maker.state == CarMaker.States.DONE:
		front_wheel = $FrontWheel/SpinningBody
		back_wheel = $BackWheel/SpinningBody
	
		#Chassis
		$CollisionShape2D.shape = ConvexPolygonShape2D.new()
		$CollisionShape2D.shape.points = car_maker.convex_hull
		add_child(get_line2d(car_maker.chassis_line_points))
		for i in range(car_maker.chassis_deco.size()):
			if (car_maker.chassis_deco[i]):
				add_child(get_line2d(car_maker.chassis_deco[i], car_maker.chassis_deco_color[i], car_maker.chassis_deco_width[i]))

		#Backwheel
		back_wheel.add_child(get_line2d(car_maker.left_wheel_line_points))
		
		for i in range(car_maker.left_wheel_deco.size()):
			if (car_maker.left_wheel_deco[i]):
				back_wheel.add_child(get_line2d(car_maker.left_wheel_deco[i], car_maker.left_wheel_deco_color[i], car_maker.left_wheel_deco_width[i]))
		back_wheel.get_parent().set_wheel_polygon(car_maker.left_wheel_hull)

		#Frontwheel
		front_wheel.add_child(get_line2d(car_maker.right_wheel_line_points))
		
		for i in range(car_maker.right_wheel_deco.size()):
			if (car_maker.right_wheel_deco[i]):
				front_wheel.add_child(get_line2d(car_maker.right_wheel_deco[i], car_maker.right_wheel_deco_color[i], car_maker.right_wheel_deco_width[i]))
		front_wheel.get_parent().set_wheel_polygon(car_maker.right_wheel_hull)
		
		#Cannon
		for i in range(car_maker.cannon_deco.size()):
			if (car_maker.cannon_deco[i]):
				$Cannon.add_child(get_line2d(car_maker.cannon_deco[i], car_maker.cannon_color[i], car_maker.cannon_width[i]))

		#Bullet
		bullet_info["hull"] = car_maker.projectile_hull
		bullet_info["line"] = car_maker.projectile_line_points
		bullet_info["deco"] = car_maker.projectile_deco
		bullet_info["deco_color"] = car_maker.projectile_deco_color
		bullet_info["deco_width"] = car_maker.projectile_deco_width

		area = ConvexPolygonArea.get_convex_polygon_area(car_maker.convex_hull)
		
func get_line2d(car_maker_points, color = null, width = null):
	var line = Line2D.new()
	line.position -= Global.canvas_offset
	if color != null:
		line.default_color = color
	if width != null:
		line.width = width
	for point in car_maker_points:
		line.add_point(point)
	return line
