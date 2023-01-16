class_name CardManager
extends Node

signal used_card(card)

var _deck := [
	AttackCard.new("Attack", "1 damage", 0.5, [], 1, "res://Projectiles/BasicAttack.tscn"),
	AttackCard.new("Attack", "1 damage", 0.5, [], 1, "res://Projectiles/BasicAttack.tscn"),
	AttackCard.new("Attack", "1 damage", 0.5, [], 1, "res://Projectiles/BasicAttack.tscn"),
	AttackCard.new("Attack", "1 damage", 0.5, [], 1, "res://Projectiles/BasicAttack.tscn"),
]
var _slots_available := [true, true, true]
var _cards := []
var _discard := []

onready var _slot_timers := [
	$Slot1Timer,
	$Slot2Timer,
	$Slot3Timer
]


func _ready()->void:
	for i in 3:
		_cards.append(_deck[0])
		_deck.remove(0)


func _process(_delta:float)->void:
	if Input.is_action_just_pressed("spell_slot_1") and _slots_available[0]:
		_use_slot(0)
	if Input.is_action_just_pressed("spell_slot_2") and _slots_available[1]:
		_use_slot(1)
	if Input.is_action_just_pressed("spell_slot_3") and _slots_available[2]:
		_use_slot(2)


func _use_slot(slot_index:int)->void:
	if _cards[slot_index] != null:
		
		_slots_available[slot_index] = false
		_slot_timers[slot_index].start(_cards[slot_index].cast_time)
		
		emit_signal("used_card", _cards[slot_index])
		
		_discard_card(slot_index)
		
		yield(_slot_timers[slot_index], "timeout")
		
		_draw_card(slot_index)
		_slots_available[slot_index] = true


func _discard_card(slot_index:int)->void:
	_discard.append(_cards[slot_index])
	_cards[slot_index] = null


func _draw_card(to:int)->void:
	if _deck.size() > 0:
		_cards[to] = _deck[0]
		_deck.remove(0)
	else:
		yield($RefreshTimer, "timeout")
		_draw_card(to)


func _on_RefreshTimer_timeout()->void:
	_refresh_card()


func _refresh_card()->void:
	if _discard.size() > 0:
		_deck.append(_discard[0])
		_discard.remove(0)
