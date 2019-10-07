class_name StringPoolConverter

	
static func string_to_float_array(string : String) -> Array:
	var return_value = []
	
	for string_value in string.substr(1, string.length()-1).split(","):
		return_value.append(float(string_value))
	
	return return_value
	
static func string_to_color_array(string : String) -> Array:
	var return_value = []
	
	var substrings = string.substr(1, string.length()-1).split(",")
	for i in range(0, substrings.size(), 4):
		return_value.append(Color(float(substrings[i]),float(substrings[i+1]),float(substrings[i+2]),float(substrings[i+3])))
	
	return return_value
	
static func string_to_vector2_array_array(string : String) -> Array:
	var return_value := []
	var checkpoint := 0
	string = string.substr(1, string.length()-1)
	while true:
		var open_bracket = string.find("[", checkpoint)
		if open_bracket == -1:
			break
		
		var close_bracket = string.find("]", open_bracket)
		checkpoint = close_bracket
		return_value.append(string_to_pool_array(string.substr(open_bracket, close_bracket-open_bracket)))
	return return_value
	
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
