class_name AttackCard
extends Card

var damage := 0
var projectile_path := ""


func _init(new_name := "", new_text := "",
		new_cast_time := 0.0, new_flags := [],
		new_damage := 0, new_projectile_path := ""
	)->void:
	
	._init(new_name, new_text, new_cast_time, new_flags)
	
	damage = new_damage
	projectile_path = new_projectile_path
	type = Type.ATTACK
