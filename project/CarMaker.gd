extends Node

enum States {
	CHASSIS, CHASSIS_DECO, LEFT_WHEEL, LEFT_WHEEL_DECO,
	RIGHT_WHEEL, RIGHT_WHEEL_DECO, CANNON, PLACE_CANNON,
	PROJECTILE, PROJECTILE_DECO, DONE}

const STATES_NAME = [
	"Chassis", "Chassis Decoration", "Left Wheel", "Left Wheel Decoration",
	"Right Wheel", "Right Wheel Decoration",
	"Cannon", "Place Cannon", "Projectile", "Projectile Decoration", "Done"
]
const STATES_IMAGES = [
	"res://assets/carro.png", "res://assets/carro.png", "res://assets/roda.png",
	"res://assets/roda.png", "res://assets/roda.png", "res://assets/roda.png",
	"res://assets/canhao.png", "res://assets/carro.png", "res://assets/bala.png", "res://assets/bala.png"
]

var convex_hull : PoolVector2Array
var left_wheel_hull : PoolVector2Array
var left_wheel_line : Line2D
var left_wheel_deco : Array
var right_wheel_hull : PoolVector2Array
var right_wheel_line : Line2D
var right_wheel_deco : Array
var outline : Line2D
var outlines : Array
var chassis_line : Line2D
var chassis_deco : Array
var cannon : Array
var cannon_position : Vector2
var projectile_hull : PoolVector2Array
var projectile_line : Line2D
var projectile_deco : Array
var state = States.CHASSIS
var placing_object : Array

func _ready():
	var convex_hull : PoolVector2Array
	var left_wheel_hull : PoolVector2Array
	var left_wheel_line : Line2D
	var right_wheel_hull : PoolVector2Array
	var right_wheel_line : Line2D
	var outline : Line2D
	var chassis_line : Line2D
	var chassis_deco : Array
	var cannon : Array
	var projectile_hull : PoolVector2Array
	var projectile_line : Line2D
	var projectile_deco : Array


