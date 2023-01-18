class_name Card
extends Object

enum Type {ATTACK, DEFENSE, HEX, RITUAL}
enum Flags {RUNE, GLYPH}

var card_name := ""
var card_text := ""
var cast_time := 0.0
var type : int
var flags := []
var statuses := {}


func _init(new_name := "", new_text := "", new_cast_time := 0.0, new_flags := [], new_statuses := {})->void:
	card_name = new_name
	card_text = new_text
	cast_time = new_cast_time
	flags = new_flags
	statuses = new_statuses
