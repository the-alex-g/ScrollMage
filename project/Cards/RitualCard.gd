class_name RitualCard
extends Card

var duration := 0


func _init(new_name := "", new_text := "", new_cast_time := 0.0, new_flags := [], new_statuses := {}, new_duration := 0)->void:
	._init(new_name, new_text, new_cast_time, new_flags, new_statuses)
	duration = new_duration
	type = Type.RITUAL
