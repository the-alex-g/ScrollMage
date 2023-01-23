class_name StatusDisplay
extends Node2D

const POINTS = 32
const STATUS_SPACING_PX := 10.0

export(int, 0, 360) var arc := 360
export var radius := 0

var _current_statuses := []

onready var _path : Path2D = $Path
onready var _status_position : PathFollow2D = $Path/StatusPosition
onready var _status_container : Node2D = $StatusContainer
onready var _status_spacing := (STATUS_SPACING_PX / radius * 360) / (TAU * arc)


func _ready()->void:
	print(_status_spacing)
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
		
		var starting_point = 0.5 - _status_spacing * 0.5 * (new_statuses.size() - 1)
		
		for i in new_statuses.size():
			_status_position.unit_offset = starting_point + _status_spacing * i
			
			var sprite := Sprite.new()
			sprite.texture = load("res://Resources/StatusTextures/" + new_statuses[i] + "_texture.tres")
			sprite.position = _path.position + _status_position.position
			
			_status_container.add_child(sprite)
