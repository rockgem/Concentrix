extends Node

var save_file_name = 'user://save_.json'


var world_ref = null


func create_save():
	var file: Dictionary = {
		'sliders': []
	}
	
	var sliders = []
	for i in get_tree().get_nodes_in_group('Point'):
		if i.type == 0:
			sliders.append(i)
			
			var data = {
				'rotation': i.rotation,
				'angle': i.global_position.angle_to(world_ref.center.global_position),
				'length_x': 0.0,
				'length_y': 0.0,
			}
	
	
	var f = FileAccess.open('user://save_%s.json' % randi(), FileAccess.WRITE)
	f.store_string(JSON.stringify(file))
	
	f.close()



func get_sliders():
	var sliders = []
	
	for p in get_tree().get_nodes_in_group('Point'):
		if p.type == 0:
			sliders.append(p)
	
	return sliders
