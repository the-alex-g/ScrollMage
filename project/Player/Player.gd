class_name Player
extends Creature

signal update_statuses(new_statuses)
signal update_health(new_health, new_max)
signal damage

export var speed := 200.0

onready var _attack_range : Area2D = $AttackRange
onready var _hinge : Node2D = $Hinge
onready var _attack_point : Position2D = $Hinge/AttackPoint


func _physics_process(delta:float)->void:
	var direction := Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	
	# warning-ignore:return_value_discarded
	move_and_collide(direction * speed * delta * _get_speed_modifier())
	
	_get_new_target()
	if _target != null:
		_hinge.rotation = get_angle_to(_target.global_position)
	
	emit_signal("update_statuses", statuses)


func _get_new_target()->void:
	var elegible_bodies := _attack_range.get_overlapping_bodies()
	if elegible_bodies.size() > 0:
		if _target == null:
			_target = elegible_bodies[0]
		for body in elegible_bodies:
			if global_position.distance_squared_to(body.global_position) < global_position.distance_squared_to(_target.global_position):
				_target = body
	else:
		_target = null


func _draw()->void:
	draw_circle(Vector2.ZERO, 10, Color.whitesmoke)


func resolve_card(card:Card)->void:
	match card.type:
		Card.Type.ATTACK:
			_attack(card)
		Card.Type.DEFENSE:
			_defense(card)
		Card.Type.HEX:
			_hex(card)
		Card.Type.RITUAL:
			_ritual(card)


func _attack(card:AttackCard)->void:
	if _is_target_in_LoS():
		var attack : Attack = load(card.projectile_path).instance()
		attack.damage = _mod_damage(card.damage)
		attack.from = _attack_point.global_position
		attack.target_point = _target.global_position
		attack.statuses = card.statuses
		_apply_statuses(card.attacker_boosts)
		get_parent().add_child(attack)


func _defense(card:BoostCard)->void:
	_apply_statuses(card.statuses)


func _hex(card:HexCard)->void:
	if _is_target_in_LoS():
		_target.hit(0, card.statuses)


func _ritual(card:RitualCard)->void:
	_apply_ritual(card.statuses, card.duration)


func hit(damage:int, applied_statuses := {}, blockable := true)->void:
	.hit(damage, applied_statuses)
	
	if blockable and damage > 0:
		# warning-ignore:narrowing_conversion
		damage = max(0, damage - statuses.block)
		if statuses.corrosion > 0:
			damage += 1
		if statuses.vulnerable > 0:
			# warning-ignore:narrowing_conversion
			damage *= 1.25
	
	health -= damage
	
	while health <= 0:
		emit_signal("damage")
		health += _max_health
	
	emit_signal("update_health", health, _max_health)


func heal(amount:int)->void:
	.heal(amount)
	emit_signal("update_health", health, _max_health)
