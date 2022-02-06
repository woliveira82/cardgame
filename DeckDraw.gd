extends TextureButton

var deck_size: int = 60


func _on_DeckDraw_pressed():
	if deck_size > 0:
		deck_size = $"../../".draw_card()
		if deck_size == 0:
			disabled = true
