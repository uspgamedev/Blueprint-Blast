extends Node
class_name CarMaker

enum States {
	CHASSIS, CHASSIS_DECO, LEFT_WHEEL, LEFT_WHEEL_DECO,
	RIGHT_WHEEL, RIGHT_WHEEL_DECO, CANNON,
	PROJECTILE, PROJECTILE_DECO, MUSIC, GALLERY}

const STATES_NAME = [
	"Chassis", "Chassis Decoration", "Left Wheel", "Left Wheel Decoration",
	"Right Wheel", "Right Wheel Decoration",
	"Cannon", "Projectile", "Projectile Decoration", "Music"
]

const STORY_NAME = [
	"Lets draw a car", "This car is boring, lets pimp it up", "We need a wheel", "Pimp that wheel",
	"pretty sure cars need two wheels", "That other one too",
	"Lets get explosive, draw a cannon", "We'll need a projectile to shoot", "Make it DANGEROUS", "Music"
]

const STATES_IMAGES = [
	"res://assets/carro.png", "res://assets/carro.png", "res://assets/roda.png",
	"res://assets/roda.png", "res://assets/roda.png", "res://assets/roda.png",
	"res://assets/canhao.png", "res://assets/bala.png", "res://assets/bala.png"
]

var convex_hull : PoolVector2Array
var left_wheel_hull : PoolVector2Array
var left_wheel_line_points : PoolVector2Array
var left_wheel_deco : Array
var left_wheel_deco_color : Array
var left_wheel_deco_width : Array
var right_wheel_hull : PoolVector2Array
var right_wheel_line_points : PoolVector2Array
var right_wheel_deco : Array
var right_wheel_deco_color : Array
var right_wheel_deco_width : Array
var outline : Line2D
var chassis_outline : Line2D
var left_wheel_outline : Line2D
var right_wheel_outline : Line2D
var chassis_line_points : PoolVector2Array
var chassis_deco : Array
var chassis_deco_color : Array
var chassis_deco_width : Array
var cannon_deco : Array
var cannon_color : Array
var cannon_width : Array
var projectile_hull : PoolVector2Array
var projectile_line_points : PoolVector2Array
var projectile_deco : Array
var projectile_deco_color : Array
var projectile_deco_width : Array
var state = States.CHASSIS

func _init():
	# Weird fix because godot starts using the same array for all objects
	cannon_deco = []
	cannon_color = []
	cannon_width = []
	left_wheel_deco = []
	left_wheel_deco_color = []
	left_wheel_deco_width = []
	right_wheel_deco = []
	right_wheel_deco_color = []
	right_wheel_deco_width = []
	chassis_deco = []
	chassis_deco_color = []
	chassis_deco_width = []
	projectile_deco = []
	projectile_deco_color = []
	projectile_deco_width = []
	
func load_from_string(file : File):
	var index = 1

	while not file.eof_reached():
		var name = file.get_line()
		var value = file.get_line()
		var type = typeof(self.get(name))
		match type:
			TYPE_VECTOR2_ARRAY:
				self.set(name, StringPoolConverter.string_to_pool_array(value))
			TYPE_ARRAY:
				if name.ends_with("_color"):
					self.set(name, StringPoolConverter.string_to_color_array(value))
				elif name.ends_with("_width"):
					self.set(name, StringPoolConverter.string_to_float_array(value))
				elif name.ends_with("_deco"):
					self.set(name, StringPoolConverter.string_to_vector2_array_array(value))

			
		index += 2