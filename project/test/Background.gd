extends CanvasLayer

func _ready():
	randomize()
	var index = randi()%16+1
	$Texture.texture = load(str("res://assets/skies/",index,".png"))
