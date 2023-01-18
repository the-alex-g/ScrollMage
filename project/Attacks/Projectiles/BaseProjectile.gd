class_name Projectile
extends Attack

export var speed := 300.0

func _ready()->void:
	global_position = from
	look_at(target_point)


func _physics_process(delta:float)->void:
	var collision := move_and_collide(Vector2.RIGHT.rotated(rotation) * speed * delta)
	if collision != null:
		_resolve_collision(collision.collider)


func _resolve_collision(collider:PhysicsBody2D)->void:
	if collider.has_method("hit"):
		collider.hit(damage, statuses)
	
	queue_free()


func _draw()->void:
	draw_circle(Vector2.ZERO, 5, Color.black)
