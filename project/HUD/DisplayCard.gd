extends Control

onready var _title_label : Label = $TitleLabel
onready var _description_label : Label = $DescriptionLabel
onready var _flag_label : Label = $FlagLabel


func build(card:Card)->void:
	if card == null:
		_clear_card()
	else:
		_title_label.text = card.card_name
		
		for flag in card.flags:
			_flag_label.text += str(flag) + " "
		
		_description_label.text = card.card_text


func _clear_card()->void:
	_title_label.text = ""
	_flag_label.text = ""
	_description_label.text = ""
