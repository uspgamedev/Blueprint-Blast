extends BaseCar

func _ready():
	force = 20

func _physics_process(delta):
	update_movement()

func update_movement():
	back_wheel.apply_torque_impulse(force)
	front_wheel.apply_torque_impulse(force)
