class_name Monster
extends Creature

export var detection_distance := 0
export var speed := 0
export var action_load_paths := ["res://Monsters/MonsterActions/ActionSets/TestActionSet.gd"]

var _target_in_range := false
var _actions := []
var _lost_actions := []
var _can_act := true

onready var _detection_region : Area2D = $DetectionRegion
onready var _detection_region_collision : CollisionShape2D = $DetectionRegion/CollisionShape2D
onready var _action_timer : Timer = $ActionTimer
onready var _ranged_attack_spawn_point : Position2D = $RangedAttackSpawnPoint


func _ready()->void:
	_max_health = health
	
	for path in action_load_paths:
		_actions.append_array(load(path).new().actions)
	_actions.shuffle()
	
	var new_collision := CircleShape2D.new()
	new_collision.radius = detection_distance
	_detection_region_collision.shape = new_collision


func _physics_process(delta:float)->void:
	if _is_target_in_LoS():
		look_at(_target.global_position)
		
		var next_action : MonsterAction = _actions[0]
		match next_action.type:
			MonsterAction.Types.ATTACK, MonsterAction.Types.RANGED, MonsterAction.Types.HEX:
				if global_position.distance_squared_to(_target.global_position) > pow(next_action.attack_range, 2):
					# warning-ignore:return_value_discarded
					move_and_collide(Vector2.RIGHT.rotated(rotation) * speed * delta)
				elif _can_act:
					_resolve_next_action()
			MonsterAction.Types.BOOST, MonsterAction.Types.RITUAL:
				if _can_act:
					_resolve_next_action()
	elif not _target_in_range:
		_target = null
	
	_status_display.rotation = -rotation


func _resolve_next_action()->void:
	var action : MonsterAction = _actions[0]
	_can_act = false
	
	match action.type:
		MonsterAction.Types.ATTACK:
			_melee_attack(action)
		MonsterAction.Types.RANGED:
			_ranged_attack(action)
		MonsterAction.Types.BOOST:
			_boost(action)
		MonsterAction.Types.HEX:
			_hex(action)
		MonsterAction.Types.RITUAL:
			_ritual(action)
	
	if action.type != MonsterAction.Types.RITUAL:
		_actions.append(action)
	_actions.remove(0)
	
	var delay_time := action.delay_time
	if statuses.swift_act > 0:
		delay_time *= 0.75
	
	_action_timer.start(delay_time)
	yield(_action_timer, "timeout")
	_can_act = true


func _melee_attack(action:AttackAction)->void:
	_target.hit(action.damage, action.statuses)


func _ranged_attack(action:RangedAttackAction)->void:
	var attack : Attack = load(action.projectile_path).instance()
	attack.damage = action.damage
	attack.from = _ranged_attack_spawn_point.global_position
	attack.target_point = _target.global_position
	attack.statuses = action.statuses
	_apply_statuses(action.attacker_boosts)
	get_parent().add_child(attack)


func _boost(action:BoostAction)->void:
	_apply_statuses(action.statuses)


func _hex(action:HexAction)->void:
	_target.hit(0, action.statuses)


func _ritual(action:MonsterRitual)->void:
	_lost_actions.append(action)
	_apply_ritual(action.statuses, action.duration)
	
	var timer := Timer.new()
	add_child(timer)
	timer.start(action.duration)
	yield(timer, "timeout")
	
	_lost_actions.erase(action)
	_actions.append(action)


func _on_DetectionRegion_body_entered(body:PhysicsBody2D)->void:
	if body is Player:
		_target = body
		_target_in_range = true


func _on_DetectionRegion_body_exited(body:PhysicsBody2D)->void:
	if _target != null:
		if body == _target:
			_target_in_range = false


func _die()->void:
	queue_free()


func _draw()->void:
	draw_circle(Vector2.ZERO, 8, Color.red)


func hit(damage:int, applied_statuses := {}, blockable := true)->void:
	.hit(damage, applied_statuses)
	# warning-ignore:narrowing_conversion
	if blockable:
		health -= max(0, damage - statuses.block)
	
	if health <= 0:
		_die()
