extends Label



var triangle_line = null


func _physics_process(delta):
	if triangle_line and is_instance_valid(triangle_line):
		text = ''
		text += '\n'
		text += '\nX Length: %s' % snapped(triangle_line.get_length().x, 0.01)
		text += '\nY Length: %s' % snapped(triangle_line.get_length().y, 0.01)
		text += '\nAngle: %s' % snapped(triangle_line.get_angle(), 0.01)
