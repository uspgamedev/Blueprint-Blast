extends CanvasLayer

func _ready():
	var index = randi()%18+1
	$Texture.texture = load(str("res://assets/skies/",index,".png"))
