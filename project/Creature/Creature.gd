class_name Creature
extends KinematicBody2D

export var status_decay_time := 1.0

var statuses := {
	"block":0,
	"poison":0,
	"swift_act":0,
}
var rituals := []


func _ready()->void:
	_decay_statuses()


func _decay_statuses()->void:
	if statuses.poison > 0:
		_resolve_poison(statuses.poison)
	
	# decay
	for status in statuses:
		statuses[status] = max(0, statuses[status] - 1)
	
	var finished_rituals := []
	for ritual in rituals:
		_apply_statuses(ritual.statuses, true)
		ritual.duration -= 1
		if ritual.duration <= 0:
			finished_rituals.append(ritual)
	
	for ritual in finished_rituals:
		rituals.erase(ritual)
	
	# wait, then run again
	yield(get_tree().create_timer(status_decay_time), "timeout")
	_decay_statuses()


func _resolve_poison(_poison:int)->void:
	pass


func _apply_statuses(new_statuses:Dictionary, ritual := false)->void:
	for status in new_statuses:
		if ritual:
			if statuses[status] < new_statuses[status]:
				statuses[status] = new_statuses[status]
		else:
			statuses[status] += new_statuses[status]


func _apply_ritual(ritual_statuses:Dictionary, duration:int)->void:
	var ritual := {"statuses":ritual_statuses, "duration":duration}
	rituals.append(ritual)


func hit(_damage:int, applied_statuses:Dictionary)->void:
	_apply_statuses(applied_statuses)
