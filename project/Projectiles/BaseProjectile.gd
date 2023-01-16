class_name Projectile
extends KinematicBody2D

export var speed := 100.0

var damage := 0
var direction := 0.0


func _physics_process(delta:float)->void:
	var collision := move_and_collide(Vector2.RIGHT.rotated(direction) * speed * delta)
	if collision != null:
		_resolve_collision(collision.collider)


func _resolve_collision(collider:PhysicsBody2D)->void:
	if collider.has_method("hit"):
		collider.hit(damage)
	
	queue_free()


func _draw()->void:
	draw_circle(Vector2.ZERO, 5, Color.black)
