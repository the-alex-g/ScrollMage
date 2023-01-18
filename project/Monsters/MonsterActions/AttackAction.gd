class_name AttackAction
extends MonsterAction

var attack_range := 0.0
var damage := 0


func _init(new_delay_time := 0.0, new_statuses := {}, new_damage := 0, new_attack_range := 0.0)->void:
	._init(new_delay_time, new_statuses)
	attack_range = new_attack_range
	damage = new_damage
	type = Types.ATTACK
