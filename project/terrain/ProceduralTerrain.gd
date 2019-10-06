
extends StaticBody2D

var points = PoolVector2Array()

func _ready():
#	var plane_size = 1000
#	points.append(Vector2(0, 50))
#	points.append(Vector2(1000, 50))
#	for x in range(0, 100000, 100):
#		var point = Vector2(x + plane_size, 50*cos(x*PI/500))
#		points.append(point)
#	points.append(Vector2(points[points.size()-1].x, 100))
#	points.append(Vector2(0, 100))
	randomize()
	
	points.append(Vector2(0, 0))
	points.append(Vector2(950, 0))
	
	var vector = Vector2(1, 0)
	var bias = 0
	for x in range(1000, 20000, 50):
		if x % 1000 == 0:
			bias = (PI/8 + PI/12 * randf()) * (1 - 2 * (randi() % 2))
		var rand = gaussian(bias, PI/(float(130-10*Global.terrain_difficulty) / 3)) # Formula for (1,40)(10,10)
		vector = vector.rotated(rand)
		vector *= 100.0/vector.x
		points.append(Vector2(x, vector.y))
		vector = Vector2(1, 0)
	
	for i in range(2, points.size() - 2):
		points[i].y = (points[i-2].y + points[i-1].y + points[i].y + points[i+1].y + points[i+2].y)/5
	
	points.append(Vector2(points[points.size()-1].x, 500))
	points.append(Vector2(0, 500))
	
	$CollisionPolygon2D.polygon = points
	$Polygon2D.polygon = points

func gaussian(mean, deviation):
	var x1
	var x2
	var w
	if deviation == 0:
		return mean
	while true:
		x1 = rand_range(0, 2) - 1
		x2 = rand_range(0, 2) - 1
		w = x1*x1 + x2*x2
		if 0 < w and w < 1:
			break
	w = sqrt(-2 * log(w)/w)
	return mean + deviation * x1 * w

#func _input(event):
#	if event.is_action_pressed("ui_up"):
#		$Camera2D.zoom *= .5
#	elif event.is_action_pressed("ui_down"):
#		$Camera2D.zoom *= 2
#	elif event.is_action_pressed("ui_right"):
#		$Camera2D.offset.x += 1000
#	elif event.is_action_pressed("ui_left"):
#		$Camera2D.offset.x -= 1000
