class_name AttackCard
extends Card

var damage := 0
var projectile_path := ""
var attacker_boosts := {}


func _init(new_name := "", new_text := "", new_cast_time := 0.0, new_flags := [], new_statuses := {},
		new_damage := 0, new_projectile_path := "", new_attacker_boosts := {}
	)->void:
	
	._init(new_name, new_text, new_cast_time, new_flags, new_statuses)
	
	damage = new_damage
	projectile_path = new_projectile_path
	attacker_boosts = new_attacker_boosts
	type = Type.ATTACK
