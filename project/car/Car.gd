extends RigidBody2D

func _ready():
	friction = 0.1

func _physics_process(delta):
	update_movement()

func update_movement():
	var vector := Vector2(0, 0)
	if Input.is_action_pressed("reverse"):
		vector += Vector2(-1, 0)
	if Input.is_action_pressed("accelerate"):
		vector += Vector2(1, 0)
	applied_force = vector.normalized() * 100
