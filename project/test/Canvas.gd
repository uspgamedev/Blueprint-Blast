extends TextureRect

onready var line = $Line2D

const POINTS_TIME = .01
const POINTS_DIST = 1

var is_drawing = false
var can_draw = true
var drawing_scale = 1
var time = 0

func _input(event):
#	if event.is_action_pressed("canvas_clear"):
#		clear()
	if event.is_action_pressed("canvas_click") and can_draw:
		var point = get_local_mouse_position()
		if point.x >= 0 and point.x <= rect_size.x and point.y >= 0 and point.y <= rect_size.y:
			is_drawing = true
			time = 0
			line.add_point(point)
	elif event.is_action_released("canvas_click"):
		if is_drawing:
			can_draw = false
			line.add_point(line.get_point_position(0))
		is_drawing = false


func _process(delta):
	if is_drawing and Input.is_action_pressed("canvas_click"):
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

func get_line():
	return line.duplicate()

func get_scaled_line():
	var scaled_line = line.duplicate()
	var center = rect_size/2
	for i in range(scaled_line.get_point_count()):
		var point = scaled_line.points[i]
		scaled_line.set_point_position(i, center + (point - center)*drawing_scale)
	scaled_line.width *= drawing_scale
	return scaled_line

func get_convex_hull():
	var hull_points = PoolVector2Array()
	var center = rect_size/2
	for point in line.points:
		point = center + (point - center)*drawing_scale
		hull_points.append(point - rect_size / 2)
	return Geometry.convex_hull_2d(hull_points)
