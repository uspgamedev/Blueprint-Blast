extends Control

signal color_changed(color)
signal width_changed(width)

onready var color_rect = $VBoxContainer/ColorBox/Border/ColorRect

var width = 10

func _ready():
	pass


func _draw():
	var pos = $VBoxContainer/WidthBox/WidthCircle.rect_global_position +\
			Vector2($VBoxContainer/WidthBox/WidthCircle.rect_size.x / 2, 0)
	
	# Thanks George!
	draw_set_transform_matrix(get_global_transform().affine_inverse())
	
	draw_circle(pos, 1 + width * .5, color_rect.color)


func _on_RedSlider_value_changed(value):
	$VBoxContainer/ColorBox/RGBBox/RedBox/Label.text = str("Red: ", value)
	color_rect.color.r8 = value
	update()
	emit_signal("color_changed", color_rect.color)


func _on_GreenSlider_value_changed(value):
	$VBoxContainer/ColorBox/RGBBox/GreenBox/Label.text = str("Green: ", value)
	color_rect.color.g8 = value
	update()
	emit_signal("color_changed", color_rect.color)


func _on_BlueSlider_value_changed(value):
	$VBoxContainer/ColorBox/RGBBox/BlueBox/Label.text = str("Blue: ", value)
	color_rect.color.b8 = value
	update()
	emit_signal("color_changed", color_rect.color)


func _on_WidthSlider_value_changed(value):
	$VBoxContainer/WidthBox/WidthSliderBox/Label.text = str("Width: ", value)
	width = value
	update()
	emit_signal("width_changed", value)
