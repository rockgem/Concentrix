extends Node

var save_file_name = 'user://save_.json'


var world_ref = null


func create_save():
	var file: Dictionary = {
		'sliders': []
	}
	
	for slider in get_sliders():
		var data = {
			'rotation': slider.rotation,
			'angle': world_ref.center.global_position.angle_to(slider.get_node('Inner').global_position),
			'length_x': 0.0,
			'length_y': 0.0,
			'distances': [],
			'angles': [],
		}
		
		data['length_y'] = Vector2(world_ref.center.global_position.x, slider.get_node('Inner').global_position.y).distance_to(slider.get_node('Inner').global_position)
		data['length_x'] = Vector2(slider.get_node('Inner').global_position.x, world_ref.center.global_position.y).distance_to(slider.get_node('Inner').global_position)
		
		for s in get_sliders():
			if s == slider:
				continue
			
			var distance = s.get_node('Inner').global_position.distance_to(slider.get_node('Inner').global_position)
			var angle = s.get_node('Inner').global_position.angle_to(slider.get_node('Inner').global_position)
			data['distances'].append(distance)
			data['angles'].append(angle)
		
		file['sliders'].append(data)
	
	
	var f = FileAccess.open('user://save_%s.json' % randi(), FileAccess.WRITE)
	f.store_string(JSON.stringify(file, '', false))
	
	f.close()



func get_sliders():
	var sliders = []
	
	for p in get_tree().get_nodes_in_group('Point'):
		if p.type == 0:
			sliders.append(p)
	
	return sliders
