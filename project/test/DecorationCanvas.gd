extends TextureRect

const POINTS_TIME = .01
const POINTS_DIST = 1

var lines = []
var line_color = Color.black
var line_width = 10
var time = 0

func _input(event):
	if event.is_action_pressed("canvas_clear"):
		undo()
	elif event.is_action_pressed("canvas_click"):
		new_line()
		time = 0
		lines.back().add_point(get_local_mouse_position())
	elif event.is_action_released("canvas_click"):
		pass


func _process(delta):
	if Input.is_action_pressed("canvas_click"):
		time += delta
		while time > POINTS_TIME:
			time -= POINTS_TIME
			var point = get_local_mouse_position()
			var line = lines.back()
			point.x = clamp(point.x, 0, rect_size.x)
			point.y = clamp(point.y, 0, rect_size.y)
			if point.distance_to(line.get_point_position(line.get_point_count()-1)) > POINTS_DIST:
				line.add_point(point)


func undo():
	if lines.size():
		remove_child(lines.back())
		lines.pop_back()


func clear():
	for line in lines:
		remove_child(line)
	lines = []


func new_line():
	var line = Line2D.new()
	line.default_color = line_color
	line.width = line_width
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	add_child(line)
	lines.append(line)


func change_color(color):
	line_color = color


func change_width(width):
	line_width = width