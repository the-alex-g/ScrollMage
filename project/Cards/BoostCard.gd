class_name BoostCard
extends Card


func _init(
		new_name := "", new_text := "", new_cast_time := 0.0, new_flags := [], new_statuses := {}
	)->void:
	
	._init(new_name, new_text, new_cast_time, new_flags, new_statuses)
	type = Type.DEFENSE
