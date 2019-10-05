
extends StaticBody2D

var points = PoolVector2Array()

func _ready():
	for x in range(0, 30000, 30):
		var point = Vector2(x, 50*cos(x*PI/500))
		points.append(point)
	points.append(Vector2(points[points.size()-1].x, 100))
	points.append(Vector2(0, 100))

	$CollisionPolygon2D.polygon = points

#func _input(event):
#	if event.is_action_pressed("ui_page_up"):
#		$Camera2D.zoom *= 1.1
#	elif event.is_action_pressed("ui_page_down"):
#		$Camera2D.zoom *= .9
#	elif event.is_action_pressed("ui_right"):
#		$Camera2D.offset.x += 80
#	elif event.is_action_pressed("ui_left"):
#		$Camera2D.offset.x -= 80