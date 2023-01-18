class_name Player
extends Creature

export var speed := 200.0

var _target : Node2D = null

onready var _attack_range : Area2D = $AttackRange
onready var _hinge : Node2D = $Hinge
onready var _attack_point : Position2D = $Hinge/AttackPoint


func _physics_process(delta:float)->void:
	var direction := Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	
	# warning-ignore:return_value_discarded
	move_and_collide(direction * speed * delta)
	
	_get_new_target()
	if _target != null:
		_hinge.rotation = get_angle_to(_target.global_position)


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


func _attack(card:AttackCard)->void:
	if _target != null:
		var attack : Attack = load(card.projectile_path).instance()
		attack.damage = card.damage
		attack.from = _attack_point.global_position
		attack.target_point = _target.global_position
		get_parent().add_child(attack)


func _defense(card:BoostCard)->void:
	_apply_statuses(card.statuses)


func hit(damage_taken:int)->void:
	# warning-ignore:narrowing_conversion
	damage_taken = max(0, damage_taken - statuses.block)
	print(damage_taken)
