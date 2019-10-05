extends BaseCar

func _ready():
	max_velocity = 150

func _physics_process(delta):
	update_movement()

func update_movement():
	var vector = Vector2(1, 0)
	applied_force = vector.normalized() * acceleration
	linear_velocity = linear_velocity.normalized() * min(linear_velocity.length(), max_velocity)
