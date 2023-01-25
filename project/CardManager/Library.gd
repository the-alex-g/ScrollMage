class_name Library
extends Node

var attacks := {
	#"":{"text":"", "casting_time":0.0, "flags":[], "statuses":{}, "damage":0, "projectile_path":"", "attacker_boosts":{}}
	"Slash":{"text":"3 damage", "casting_time":0.5, "flags":[Card.Flags.GLYPH], "statuses":{}, "damage":3, "projectile_path":"res://Attacks/Projectiles/BasicAttack.tscn"},
}
var boosts := {
	#"":{"text":"", "casting_time":0.0, "flags":[], "statuses":{}},
	"Shield":{"text":"+3 block", "casting_time":0.75, "flags":[Card.Flags.RUNE], "statuses":{"block":3}},
	"Heal":{"text":"Heal 3", "casting_time":1.0, "flags":[Card.Flags.GLYPH], "statuses":{"heal":3}},
}
var hexes := {
	#"":{"text":"", "casting_time":0.0, "flags":[], "statuses":{}},
	"Poison":{"text":"2 poison", "casting_time":1.0, "flags":[Card.Flags.GLYPH], "statuses":{"poison":2}},
}
var rituals := {
	#"":{"text":"", "casting_time":0.0, "flags":[], "statuses":{}, "duration":0},
	"Armor Script":{"text":"1 block for 1 minute", "casting_time":2.0, "flags":[Card.Flags.RUNE], "statuses":{"block":1}, "duration":60},
}


func get_attack(card_name := "")->AttackCard:
	if card_name == "":
		card_name = attacks.keys()[randi() % attacks.size()]
	
	var card_info : Dictionary = attacks[card_name]
	var attack_boosts := {}
	if card_info.has("attacker_boosts"):
		attack_boosts = card_info.attacker_boosts
	
	return AttackCard.new(
		card_name, card_info.text,
		card_info.casting_time, card_info.flags,
		card_info.statuses, card_info.damage,
		card_info.projectile_path, attack_boosts
	)


func get_boost(card_name := "")->BoostCard:
	if card_name == "":
		card_name = boosts.keys()[randi() % boosts.size()]
	
	var card_info : Dictionary = boosts[card_name]
	return BoostCard.new(card_name, card_info.text, card_info.casting_time, card_info.flags, card_info.statuses)


func get_hex(card_name := "")->HexCard:
	if card_name == "":
		card_name = hexes.keys()[randi() % hexes.size()]
	
	var card_info : Dictionary = hexes[card_name]
	return HexCard.new(card_name, card_info.text, card_info.casting_time, card_info.flags, card_info.statuses)


func get_ritual(card_name := "")->RitualCard:
	if card_name == "":
		card_name = rituals.keys()[randi() % rituals.size()]
	
	var card_info : Dictionary = rituals[card_name]
	return RitualCard.new(
		card_name, card_info.text,
		card_info.casting_time, card_info.flags,
		card_info.statuses, card_info.duration
	)
