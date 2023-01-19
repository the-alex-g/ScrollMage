class_name MonsterRitual
extends MonsterAction

var duration := 0


func _init(new_delay_time := 0.0, new_statuses := {}, new_duration := 0)->void:
	._init(new_delay_time, new_statuses)
	duration = new_duration
	type = Types.RITUAL
