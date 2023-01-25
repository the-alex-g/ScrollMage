extends CanvasLayer

onready var _hand_container : HBoxContainer = $HandContainer
onready var _deck_size_label : Label = $DeckIcon/DeckSizeLabel
onready var _lost_size_label : Label = $LostIcon/LostSizeLabel
onready var _health_bar : TextureProgress = $HealthBar
onready var _cast_bar : TextureProgress = $CastBar
onready var _tween : Tween = $Tween


func update_deck(info:Dictionary)->void:
	for i in info.hand.size():
		_hand_container.get_child(i).build(info.hand[i])
	_deck_size_label.text = str(info.deck_size)
	_lost_size_label.text = str(info.lost_cards)
	
	_cast_bar.max_value = info.total_cast_time
	_cast_bar.value = info.total_cast_time - info.time_left


func update_health(new_value:int, new_max:int)->void:
	if _health_bar.max_value != new_max:
		_health_bar.max_value = new_max
	
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(_health_bar, "value", null, new_value, 0.5, Tween.TRANS_QUAD)
	# warning-ignore:return_value_discarded
	_tween.start()
