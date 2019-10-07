extends CanvasLayer

func _ready():
	randomize()
	var index = randi()%15+1
	$Texture.texture = load(str("res://assets/skies/",index,".png"))
