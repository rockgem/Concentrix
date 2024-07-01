extends Node2D



var target = null
var center = null


func _ready():
	$Line2D.add_point(center.global_position)
	$Line2D.add_point(target.global_position)


func _physics_process(delta):
	$Line2D.points[0] = center.global_position
	$Line2D.points[1] = target.global_position
