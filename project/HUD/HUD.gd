extends CanvasLayer

onready var _hand_container : HBoxContainer = $HandContainer
onready var _deck_size_label : Label = $DeckSizeLabel


func update_deck(info:Dictionary)->void:
	for i in info.hand.size():
		_hand_container.get_child(i).build(info.hand[i])
	_deck_size_label.text = str(info.deck_size)
