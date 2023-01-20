extends TextureRect

var card_built : Card

onready var _title_label : Label = $TitleLabel
onready var _description_label : Label = $DescriptionLabel
onready var _flag_label : Label = $FlagLabel
onready var _cast_time_label : Label = $CastTimeLabel


func _ready()->void:
	for child in get_children():
		if child is Label:
			child.add_font_override("font", load("res://Resources/small_font.tres").duplicate())


func build(card:Card)->void:
	if card == null:
		_clear_card()
	elif card != card_built:
		_title_label.text = card.card_name
		_cast_time_label.text = str(int(card.cast_time * 4))
		
		_flag_label.text = ""
		for flag in card.flags:
			_flag_label.text += str(Card.Flags.keys()[flag]).capitalize() + " "
		
		_resize_font(_title_label, 68)
		
		_description_label.text = card.card_text
		modulate = Color(1, 1, 1, 1)


func _clear_card()->void:
	_title_label.text = ""
	_flag_label.text = ""
	_description_label.text = ""
	_cast_time_label.text = ""
	modulate = Color(1, 1, 1, 0)


func _resize_font(on:Label, size:int)->void:
	while on.get_font("font").get_string_size(on.text).x > size:
		on.get_font("font").size -= 1
	while on.get_font("font").get_string_size(on.text).x < size - 15:
		on.get_font("font").size += 1
