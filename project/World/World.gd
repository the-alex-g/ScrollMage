extends Node2D

onready var _player := $Player


func _on_CardManager_used_card(card:Card)->void:
	_player.resolve_card(card)
