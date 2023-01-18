class_name Creature
extends KinematicBody2D

export var status_decay_time := 1.0

var statuses := {
	"block":0,
	"poison":0,
}


func _ready()->void:
	_decay_statuses()


func _decay_statuses()->void:
	if statuses.poison > 0:
		_resolve_poison(statuses.poison)
	
	# decay
	for status in statuses.keys():
		statuses[status] = max(0, statuses[status] - 1)
	
	# wait, then run again
	yield(get_tree().create_timer(status_decay_time), "timeout")
	_decay_statuses()


func _resolve_poison(_poison:int)->void:
	pass


func _apply_statuses(new_statuses:Dictionary)->void:
	for status in new_statuses:
		statuses[status] += new_statuses[status]


func hit(_damage:int, applied_statuses:Dictionary)->void:
	_apply_statuses(applied_statuses)
