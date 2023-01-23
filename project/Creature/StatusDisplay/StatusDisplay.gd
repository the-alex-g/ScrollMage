class_name StatusDisplay
extends Node2D

const POINTS = 32

export(int, 0, 360) var arc := 360
export var radius := 0

var _current_statuses := []

onready var _path : Path2D = $Path
onready var _status_position : PathFollow2D = $Path/StatusPosition
onready var _status_container : Node2D = $StatusContainer


func _ready()->void:
	var curve := Curve2D.new()
	for i in POINTS + 1:
		var point := Vector2.RIGHT * radius
		point = point.rotated(TAU * i / POINTS * arc / 360.0).rotated(deg2rad((180 - arc) / 2.0))
		curve.add_point(point)
		if i == 0:
			_status_position.position = point
		
	_path.curve = curve


func update_statuses(new_statuses:Array)->void:
	if new_statuses != _current_statuses:
		_current_statuses = new_statuses
		
		for node in _status_container.get_children():
			node.queue_free()
		
		for i in new_statuses.size():
			_status_position.unit_offset = (i + 0.5) / float(new_statuses.size())
			
			var sprite := Sprite.new()
			sprite.texture = load("res://Resources/StatusTextures/" + new_statuses[i] + "_texture.tres")
			sprite.position = _path.position + _status_position.position
			
			_status_container.add_child(sprite)
