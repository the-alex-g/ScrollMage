class_name CardManager
extends Node

signal used_card(card)

var _deck := []
var _cards := []
var _lost := []
var _rituals := []
var _can_cast := true
var info : Dictionary setget , _get_info
var _library := Library.new()
var statuses := {}

onready var _cast_timer : Timer = $CastTimer


func _ready()->void:
	for i in 4:
		_deck.append(_library.get_attack("Slash"))
		_deck.append(_library.get_boost("Shield"))
	_deck.append(_library.get_ritual("Armor Script"))
	_deck.append(_library.get_hex("Poison"))
	
	_deck.shuffle()
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
		
		var wait_time : float = _cards[slot_index].cast_time
		if statuses.swift_act > 0:
			wait_time *= 0.75
		
		_can_cast = false
		_cast_timer.start(wait_time / 2.0)
		
		emit_signal("used_card", _cards[slot_index])
		_use_card(slot_index)
		
		yield(_cast_timer, "timeout")
		
		_can_cast = true
		
		yield(get_tree().create_timer(wait_time / 2.0), "timeout")
		
		_draw_card(slot_index)


func _use_card(slot_index:int)->void:
	var card : Card = _cards[slot_index]
	_cards[slot_index] = null
	
	if card.type == Card.Type.RITUAL:
		_rituals.append(card)
		yield(get_tree().create_timer(card.duration), "timeout")
		_rituals.erase(card)
		_deck.append(card)
	else:
		_deck.append(card)


func _lose_card()->void:
	if _deck.size() > 0:
		_lost.append(_deck[0])
		_deck.remove(0)


func _draw_card(to:int)->void:
	if _deck.size() > 0:
		_cards[to] = _deck[0]
		_deck.remove(0)


func _on_RefreshTimer_timeout()->void:
	_refresh_card()


func _refresh_card()->void:
	if _lost.size() > 0:
		_deck.append(_lost[0])
		_lost.remove(0)


func _get_info()->Dictionary:
	return {"hand":_cards, "deck_size":_deck.size(), "lost_cards":_lost.size() + _rituals.size()}


func damage()->void:
	_lose_card()


func heal(amount := 0)->void:
	if amount == 0:
		amount = _lost.size()
	for _i in amount:
		_refresh_card()
