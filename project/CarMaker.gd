extends Node

enum States {CHASSIS, CHASSIS_DECO, LEFT_WHEEL, RIGHT_WHEEL, CANNON, PROJECTILE, DONE}

const STATES_NAME = ["Chassis", "Chassis Decoration", "Left Wheel", "Right Wheel", "Cannon", "Projectile", "Done"]
const STATES_IMAGES = ["res://assets/carro.png", "res://assets/carro.png", "res://assets/roda.png", "res://assets/roda.png", "res://assets/canhao.png", "res://assets/bala.png"]

var convex_hull : PoolVector2Array
var left_wheel_hull : PoolVector2Array
var left_wheel_line : Line2D
var right_wheel_hull : PoolVector2Array
var right_wheel_line : Line2D
var outline : Line2D
var chassis_line : Line2D
var chassis_deco : Array
var state = States.CHASSIS

func _ready():
	pass


