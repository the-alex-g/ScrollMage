extends Node2D

onready var _player : Player = $Player
onready var _hud := $HUD
onready var _card_manager : CardManager = $CardManager


func _ready()->void:
	randomize()


func _process(_delta:float)->void:
	_hud.update_deck(_card_manager.info)


func _on_CardManager_used_card(card:Card)->void:
	_player.resolve_card(card)


func _on_Player_update_statuses(new_statuses:Dictionary)->void:
	_card_manager.statuses = new_statuses


func _on_Player_damage()->void:
	_card_manager.damage()


func _on_Player_update_health(new_health:int, max_health:int)->void:
	_hud.update_health(new_health, max_health)
