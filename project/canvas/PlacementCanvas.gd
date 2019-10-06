extends TextureRect

var is_dragging = false

func _ready():
	assert(CarMaker.placing_object)
	
	for line in CarMaker.placing_object:
		$Object.add_child(line.duplicate())

func _input(event):
	if event.is_action_pressed("canvas_click"):
		var point = get_local_mouse_position()
		if point.x >= 0 and point.x <= rect_size.x and point.y >= 0 and point.y <= rect_size.y:
			is_dragging = true
	elif event.is_action_released("canvas_click"):
		is_dragging = false

func _process(delta):
	if is_dragging:
		var point = get_local_mouse_position()
		point.x = clamp(point.x, 0, rect_size.x)
		point.y = clamp(point.y, 0, rect_size.y)
		$Object.position = point

func get_pos():
	return $Object.position