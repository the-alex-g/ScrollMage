class_name CardManager
extends Node

signal used_card(card)

var _deck := [
#	AttackCard.new("Attack", "1 damage", 0.5, [], {}, 1, "res://Attacks/Projectiles/BaseProjectile.tscn"),
#	AttackCard.new("Attack", "1 damage", 0.5, [], {}, 1, "res://Attacks/Projectiles/BaseProjectile.tscn"),
#	AttackCard.new("Attack", "1 damage", 0.5, [], {}, 1, "res://Attacks/Projectiles/BaseProjectile.tscn"),
#	AttackCard.new("Attack", "1 damage", 0.5, [], {}, 1, "res://Attacks/Projectiles/BaseProjectile.tscn"),
	BoostCard.new("Defend", "3 block", 0.5, [], {"block":3}),
	BoostCard.new("Defend", "3 block", 0.5, [], {"block":3}),
	BoostCard.new("Defend", "3 block", 0.5, [], {"block":3}),
	BoostCard.new("Defend", "3 block", 0.5, [], {"block":3}),
]
var _cards := []
var _discard := []
var _can_cast := true
var info : Dictionary setget , _get_info

onready var _cast_timer : Timer = $CastTimer
onready var _refresh_timer : Timer = $RefreshTimer


func _ready()->void:
	for i in 3:
		_cards.append(_deck[0])
		_deck.remove(0)


func _process(_delta:float)->void:
	if _can_cast:
		if Input.is_action_just_pressed("spell_slot_1"):
			_use_slot(0)
		if Input.is_action_just_pressed("spell_slot_2"):
			_use_slot(1)
		if Input.is_action_just_pressed("spell_slot_3"):
			_use_slot(2)


func _use_slot(slot_index:int)->void:
	if _cards[slot_index] != null:
		
		_can_cast = false
		_cast_timer.start(_cards[slot_index].cast_time)
		
		emit_signal("used_card", _cards[slot_index])
		
		_discard_card(slot_index)
		
		yield(_cast_timer, "timeout")
		
		_draw_card(slot_index)
		_can_cast = true


func _discard_card(slot_index:int)->void:
	_discard.append(_cards[slot_index])
	_cards[slot_index] = null


func _draw_card(to:int)->void:
	if _deck.size() > 0:
		_cards[to] = _deck[0]
		_deck.remove(0)
	else:
		yield(_refresh_timer, "timeout")
		_draw_card(to)


func _on_RefreshTimer_timeout()->void:
	_refresh_card()


func _refresh_card()->void:
	if _discard.size() > 0:
		_deck.append(_discard[0])
		_discard.remove(0)


func _get_info()->Dictionary:
	return {"hand":_cards, "deck_size":_deck.size(), "discard_size":_discard.size()}
