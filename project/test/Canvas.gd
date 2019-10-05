extends TextureRect

onready var line = $Line2D

const POINTS_TIME = .01
const POINTS_DIST = 1

var can_draw = true
var time = 0

func _ready():
	pass


func _input(event):
	if event.is_action_pressed("clear"):
		line.points = PoolVector2Array([])
		can_draw = true
		print("clear")
	elif event.is_action_pressed("click"):
		if can_draw:
			time = 0
			line.add_point(get_global_mouse_position())
			print("begin_drawing")
	elif event.is_action_released("click"):
		if can_draw:
			can_draw = false
			line.add_point(line.get_point_position(0))
			print("end_drawing")
	elif event.is_action_pressed("add_shape"):
		if not can_draw and line.get_point_count():
			$Area2D/CollisionShape2D.shape.points = Geometry.convex_hull_2d(line.points)
			print("shape_added")


func _process(delta):
	if can_draw and Input.is_action_pressed("click"):
		time += delta
		while time > POINTS_TIME:
			time -= POINTS_TIME
			var point = get_global_mouse_position()
			if point.distance_to(line.get_point_position(line.get_point_count()-1)) > POINTS_DIST:
				line.add_point(get_global_mouse_position())