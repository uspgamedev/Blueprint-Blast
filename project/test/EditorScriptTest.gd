tool
extends EditorScript

func _run():
	var pool_array = PoolVector2Array([Vector2(2, 5), Vector2(5, 1), Vector2(-4, 3)])
	print(ConvexPolygonArea.get_convex_polygon_area(pool_array))
