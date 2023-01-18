class_name MonsterAction
extends Object

enum Types {ATTACK, RANGED, BOOST, HEX}

var type : int
var delay_time : float
var statuses := {}


func _init(new_delay_time := 0.0, new_statuses := {})->void:
	delay_time = new_delay_time
	statuses = new_statuses
