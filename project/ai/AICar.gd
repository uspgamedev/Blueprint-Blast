extends BaseCar

export var ai_force = 120

func _ready():
	force = ai_force

func _physics_process(delta):
	update_movement()
	handle_shooting()

func update_movement():
	go_forward()

func handle_shooting():
	for car in Global.car_refs:
		if car == self: continue
		var vector : Vector2 = car.global_position - global_position
		if abs(vector.angle_to(Vector2(1, 0).rotated(global_rotation))) < 0.1:
			if $BulletCooldown.time_left == 0:
				shoot(null)
