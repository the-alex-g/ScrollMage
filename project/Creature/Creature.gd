class_name Creature
extends KinematicBody2D

export var status_decay_time := 1.0

var statuses := {
	"block":0,
}


func _ready()->void:
	_decay_statuses()


func _decay_statuses()->void:
	# decay
	for status in statuses.keys():
		statuses[status] = max(0, statuses[status] - 1)
	
	# wait, then run again
	yield(get_tree().create_timer(status_decay_time), "timeout")
	_decay_statuses()


func _apply_statuses(new_statuses:Dictionary)->void:
	for status in new_statuses:
		statuses[status] += new_statuses[status]
