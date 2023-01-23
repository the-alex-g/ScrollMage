extends CanvasLayer

onready var _hand_container : HBoxContainer = $HandContainer
onready var _deck_size_label : Label = $DeckSizeLabel
onready var _lost_size_label : Label = $LostSizeLabel
onready var _health_bar : ProgressBar = $HealthBar
onready var _tween : Tween = $Tween


func update_deck(info:Dictionary)->void:
	for i in info.hand.size():
		_hand_container.get_child(i).build(info.hand[i])
	_deck_size_label.text = str(info.deck_size)
	_lost_size_label.text = str(info.lost_cards)


func update_health(new_value:int, new_max:int)->void:
	if _health_bar.max_value != new_max:
		_health_bar.max_value = new_max
	
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(_health_bar, "value", null, new_value, 0.5, Tween.TRANS_QUAD)
	# warning-ignore:return_value_discarded
	_tween.start()
