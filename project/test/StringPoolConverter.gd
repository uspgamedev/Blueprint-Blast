class_name StringPoolConverter

static func string_to_pool_array(pool_array : String) -> PoolVector2Array:
	var rv := PoolVector2Array([])
	var checkpoint := 0
	while true:
		var open_parenthesis = pool_array.find("(", checkpoint)
		if open_parenthesis == -1:
			break
		var comma = pool_array.find(",", open_parenthesis)
		var close_parenthesis = pool_array.find(")", comma)
		checkpoint = close_parenthesis
		var x = float(pool_array.substr(open_parenthesis + 1, comma - open_parenthesis))
		var y = float(pool_array.substr(comma + 1, close_parenthesis - comma))
		var vector = Vector2(x, y)
		rv.append(vector)
	return rv
