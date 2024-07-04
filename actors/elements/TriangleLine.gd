extends Node2D


var target = null
var center = null

func _ready():
	$Line1.add_point(Vector2(center.global_position.x, target.global_position.y))
	$Line1.add_point(target.global_position)
	
	$Line2.add_point(Vector2(target.global_position.x, center.global_position.y))
	$Line2.add_point(target.global_position)
	
	$Line3.add_point(center.global_position)
	$Line3.add_point(target.global_position)


func _physics_process(delta):
	$Line1.points[0] = Vector2(center.global_position.x, target.global_position.y)
	$Line1.points[1] = target.global_position
	
	$Line2.points[0] = Vector2(target.global_position.x, center.global_position.y)
	$Line2.points[1] = target.global_position
	
	$Line3.points[0] = center.global_position
	$Line3.points[1] = target.global_position


func get_angle():
	return center.global_position.angle_to(target.global_position)


func get_length():
	var length_x = snapped(Vector2(center.global_position.x, target.global_position.y).distance_to(target.global_position), 0.01)
	var length_y = snapped(Vector2(target.global_position.x, center.global_position.y).distance_to(target.global_position), 0.01)
	
	return Vector2(length_x, length_y)







