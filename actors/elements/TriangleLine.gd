extends Node2D


var target = null
var center = null

func _ready():
	$Line1.add_point(Vector2(center.global_position.x, target.global_position.y))
	$Line1.add_point(target.global_position)
		
	$Line2.add_point(Vector2(target.global_position.x, center.global_position.y))
	$Line2.add_point(target.global_position)


func _physics_process(delta):
	$Line1.points[0] = Vector2(center.global_position.x, target.global_position.y)
	$Line1.points[1] = target.global_position
	
	$Line2.points[0] = Vector2(target.global_position.x, center.global_position.y)
	$Line2.points[1] = target.global_position
	
	$Label.global_position = target.global_position
	
	var length_x = snapped(Vector2(center.global_position.x, target.global_position.y).distance_to(target.global_position), 0.01)
	var length_y = snapped(Vector2(target.global_position.x, center.global_position.y).distance_to(target.global_position), 0.01)
	$Label.text = 'X: %s \nY: %s' % [length_x, length_y]
