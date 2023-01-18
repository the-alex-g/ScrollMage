class_name RangedAttackAction
extends AttackAction

var projectile_path := ""


func _init(new_delay_time := 0.0, new_statuses := {}, new_damage := 0, new_attack_range := 0.0, new_projectile_path := "")->void:
	._init(new_delay_time, new_statuses, new_damage, new_attack_range)
	projectile_path = new_projectile_path
	type = Types.RANGED
