class_name Creature
extends KinematicBody2D

export var status_decay_time := 1.0
export var health := 0

var statuses := {
	"block":0,
	"poison":0,
	"swift_act":0,
}
var rituals := []
var _status_decay_timer := Timer.new()
var _target : Node2D

onready var _max_health := health


func _ready()->void:
	_status_decay_timer.wait_time = status_decay_time
	# warning-ignore:return_value_discarded
	_status_decay_timer.connect("timeout", self, "_decay_statuses")
	add_child(_status_decay_timer)
	_status_decay_timer.start()


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


func _resolve_poison(poison:int)->void:
	hit(poison, {}, false)


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


func _is_target_in_LoS()->bool:
	if _target != null:
		var intersection := get_world_2d().direct_space_state.intersect_ray(global_position, _target.global_position, [self])
		if intersection.size() > 0:
			return intersection.collider == _target
	return false


func hit(_damage:int, applied_statuses := {}, _blockable := true)->void:
	_apply_statuses(applied_statuses)
