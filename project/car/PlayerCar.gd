extends BaseCar
class_name PlayerCar

const TORQUE = 800
var area : float

func _ready():
	var main = get_parent()
	front_wheel = $FrontWheel/SpinningBody
	back_wheel = $BackWheel/SpinningBody
	friction = 0.2
	$BulletCooldown.wait_time = bullet_cooldown
	if main.get("car_refs"):
		main.car_refs.append(self)
	if CarMaker.state == CarMaker.States.DONE:

		#Chassis
		$CollisionShape2D.shape.points = CarMaker.convex_hull
		add_child(CarMaker.chassis_line)
		for line in CarMaker.chassis_deco:
			if (line):
				add_child(line)

		#Backwheel
		back_wheel.add_child(CarMaker.left_wheel_line)
		for line in CarMaker.left_wheel_deco:
			if (line):
				back_wheel.add_child(line)
		back_wheel.get_parent().set_wheel_polygon(CarMaker.left_wheel_hull)

		#Frontwheel
		front_wheel.add_child(CarMaker.right_wheel_line)
		for line in CarMaker.right_wheel_deco:
			if (line):
				front_wheel.add_child(line)
		front_wheel.get_parent().set_wheel_polygon(CarMaker.right_wheel_hull)

		area = ConvexPolygonArea.get_convex_polygon_area(CarMaker.convex_hull)

func _physics_process(delta):
	update_movement_with_wheels()
	handle_shooting()


func handle_shooting():
	if Input.is_action_just_pressed("shoot"):
		if $BulletCooldown.time_left == 0:
			shoot()

func update_movement_with_wheels():
	if Input.is_action_pressed("accelerate"):
		go_forward()
	if Input.is_action_pressed("reverse"):
		go_backward()

	var force = Vector2(0, 0)
	if Input.is_action_pressed("rotate_clockwise"):
		force += Vector2(0, 1)
	if Input.is_action_pressed("rotate_counter_clockwise"):
		force += Vector2(0, -1)
	back_wheel.applied_force = -force * TORQUE
	front_wheel.applied_force = force * TORQUE
