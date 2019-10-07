extends RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.winner_list_gui = self
	
func _on_list_updated(winners):
	text = " WINNERS\n"
	
	var i = 1
	for winner in winners:
		text += " " + str(i)
		if winner is AICar:
			text += ". CPU"
		else:
			text += ". Player"
		text += "\n"
		i += 1