extends KinematicBody2D

export var speed := 200.0

var _target : Node2D = null

onready var _attack_range : Area2D = $AttackRange


func _physics_process(delta:float)->void:
	var direction := Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	
	# warning-ignore:return_value_discarded
	move_and_collide(direction * speed * delta)
	
	_get_new_target()


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
