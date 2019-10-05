extends TextureRect

onready var line = $Line2D

const POINTS_TIME = .01
const POINTS_DIST = 1

var can_draw = true
var time = 0

func _input(event):
	if event.is_action_pressed("canvas_clear"):
		clear()
	elif event.is_action_pressed("canvas_click"):
		if can_draw:
			time = 0
			line.add_point(get_local_mouse_position())
	elif event.is_action_released("canvas_click"):
		if can_draw:
			can_draw = false
			line.add_point(line.get_point_position(0))


func _process(delta):
	if can_draw and Input.is_action_pressed("canvas_click"):
		time += delta
		while time > POINTS_TIME:
			time -= POINTS_TIME
			var point = get_local_mouse_position()
			point.x = clamp(point.x, 0, rect_size.x)
			point.y = clamp(point.y, 0, rect_size.y)
			if point.distance_to(line.get_point_position(line.get_point_count()-1)) > POINTS_DIST:
				line.add_point(point)


func clear():
	line.points = PoolVector2Array([])
	can_draw = true


func get_convex_hull():
	return Geometry.convex_hull_2d(line.points)
