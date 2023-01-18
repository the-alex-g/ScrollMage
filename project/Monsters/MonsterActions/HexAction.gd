class_name HexAction
extends MonsterAction

var attack_range := 0.0


func _init(new_delay_time := 0.0, new_statuses := {}, new_hex_range := 0.0)->void:
	._init(new_delay_time, new_statuses)
	attack_range = new_hex_range
	type = Types.HEX
