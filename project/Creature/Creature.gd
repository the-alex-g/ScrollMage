class_name Creature
extends KinematicBody2D

const SPECIAL_STATUSES := [
	"heal"
]

export var status_decay_time := 1.0
export var health := 0

var statuses := {
	"block":0,
	"poison":0,
	"haste":0,
	"slow":0,
	"corrosion":0,
	"strength":0,
	"weak":0,
	"retaliation":0,
	"regeneration":0,
	"vulnerable":0,
}
var rituals := []
var _target : Node2D

onready var _max_health := health
onready var _status_decay_timer : Timer = $StatusDecayTimer
onready var _status_display : StatusDisplay = $StatusDisplay


func _get_speed_modifier()->float:
	var speed_modifier := 1.0
	if statuses.haste > 0:
		speed_modifier *= 1.5
	if statuses.slow > 0:
		speed_modifier *= 0.5
	return speed_modifier


func _decay_statuses()->void:
	_resolve_statuses()
	
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
	
	_update_status_display()


func _resolve_statuses()->void:
	if statuses.poison > 0:
		_resolve_poison(statuses.poison)
	if statuses.regeneration > 0:
		_resolve_regeneration()


func _resolve_poison(poison:int)->void:
	hit(poison, {}, false)


func _resolve_regeneration()->void:
	heal(1)


func _update_status_display()->void:
	var statuses_to_update := []
	
	for status in statuses:
		if statuses[status] > 0:
			statuses_to_update.append(status)
	
	_status_display.update_statuses(statuses_to_update)


func _apply_statuses(new_statuses:Dictionary, ritual := false)->void:
	for status in new_statuses:
		if SPECIAL_STATUSES.has(status):
			_resolve_special_status(status, new_statuses[status])
		else:
			if ritual:
				if statuses[status] < new_statuses[status]:
					statuses[status] = new_statuses[status]
			else:
				statuses[status] += new_statuses[status]
	
	_update_status_display()


func _resolve_special_status(status:String, amount:int)->void:
	match status:
		"heal":
			heal(amount)


func _apply_ritual(ritual_statuses:Dictionary, duration:int)->void:
	var ritual := {"statuses":ritual_statuses, "duration":duration}
	rituals.append(ritual)


func _is_target_in_LoS()->bool:
	if _target != null:
		var intersection := get_world_2d().direct_space_state.intersect_ray(global_position, _target.global_position, [self])
		if intersection.size() > 0:
			return intersection.collider == _target
	return false


func _mod_damage(damage:int)->int:
	if statuses.corrosion > 0:
		damage -= 1
	damage += statuses.strength
	if statuses.weak > 0:
		# warning-ignore:narrowing_conversion
		damage *= 0.75
	return damage


func _on_StatusDecayTimer_timeout()->void:
	_decay_statuses()


func hit(_damage:int, applied_statuses := {}, _blockable := true)->void:
	_apply_statuses(applied_statuses)


func heal(amount:int)->void:
	if health + amount <= _max_health:
		health += amount
	elif health < _max_health:
		health = _max_health
