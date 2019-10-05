class_name ConvexPolygonArea

static func get_convex_polygon_area(pool_array : PoolVector2Array) -> float:
	var area : float
	var constant : float = 1.0/2
	var left_summation := 0.0
	var right_summation := 0.0
	var rv : float
	for i in range(pool_array.size()):
		var upper_point = pool_array[i]
		var lower_point = pool_array[(i + 1) % pool_array.size()]
		left_summation += upper_point.x * lower_point.y
		right_summation += upper_point.y * lower_point.x
	rv = constant * (left_summation - right_summation)
	assert(rv >= 0)
	return rv
