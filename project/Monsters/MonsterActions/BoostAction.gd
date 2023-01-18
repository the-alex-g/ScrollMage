class_name BoostAction
extends MonsterAction


func _init(new_delay_time := 0.0, new_statuses := {})->void:
	._init(new_delay_time, new_statuses)
	type = Types.BOOST
