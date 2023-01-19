extends TextureRect

onready var _title_label : Label = $TitleLabel
onready var _description_label : Label = $DescriptionLabel
onready var _flag_label : Label = $FlagLabel
onready var _cast_time_label : Label = $CastTimeLabel


func build(card:Card)->void:
	if card == null:
		_clear_card()
	else:
		_title_label.text = card.card_name
		_cast_time_label.text = str(int(card.cast_time * 2))
		
		for flag in card.flags:
			_flag_label.text += str(flag) + " "
		
		_description_label.text = card.card_text
		modulate = Color(1, 1, 1, 1)


func _clear_card()->void:
	_title_label.text = ""
	_flag_label.text = ""
	_description_label.text = ""
	_cast_time_label.text = ""
	modulate = Color(1, 1, 1, 0)
