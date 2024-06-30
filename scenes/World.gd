@tool
extends Node2D

signal circles_count_increased
signal circles_count_decreased
signal distance_changed


var circles_count: int = 3 : 
	set(value):
		if value > circles_count:
			circles_count_increased.emit()
		elif value < circles_count:
			circles_count_decreased.emit()
		
		circles_count = value

var distance = 60.0 : 
	set(value):
		distance = value
		
		distance_changed.emit()





func _ready():
	circles_count_increased.connect(on_circles_count_increased)
	circles_count_decreased.connect(on_circles_count_decreased)
	distance_changed.connect(on_distance_changed)
	
	add_circles(circles_count)
	#add_station_to_circle(1, 1, 36.0, 655, 'square', Color.GREEN, .34)
	#add_station_to_circle(1, 1, 240.0, 400, 'circle', Color.BLUE, .48)
	#add_station_to_circle(2, 1, 89.0, 300, 'circle')
	#add_station_to_circle(3, 1, 89.0, 300, 'triangle', Color.RED)
	
	change_background_color(Color.DIM_GRAY)
	
	var count = 1
	for circle in $Sort.get_children():
		for i in 12:
			add_station_to_circle(count, 1, i * PI / 6, 655, 'circle', Color.SKY_BLUE)
		
		count += 1


func delete_all():
	for child in $Sort.get_children():
		child.queue_free()


func add_circles(amount):
	var d = $Sort.get_child_count() * distance
	
	for i in range(amount):
		var c = load("res://actors/Circle.tscn").instantiate()
		c.length += d
		c.position = $Center.global_position
		
		$Sort.add_child(c)
		
		d += distance
		
		var obj = load("res://actors/elements/Point.tscn").instantiate()
		obj.type = 0
		obj.z_index = 99
		c.add_object(obj)


func add_station_to_circle(idx, amount = 1, rot = 0.0, sound_hz = 48.0, shape = 'circle', shape_color: Color = Color.WHITE, size = 0.32):
	var circle = $Sort.get_child(idx - 1)
	
	if circle == null:
		print('no circle in that index!')
		return
	else:
		for i in amount:
			var station = load("res://actors/elements/Point.tscn").instantiate()
			station.type = 1
			station.sound_hz = sound_hz
			station.get_node('Inner/Circle').texture = load("res://art/%s.png" % shape)
			station.get_node('Inner/Circle').modulate = shape_color
			station.get_node('Inner/Circle').scale = Vector2(size, size)
			
			circle.add_object(station, rot)


func change_background_color(color):
	$CanvasLayer/Background.color = color


func on_circles_count_increased():
	add_circles(1)


func on_circles_count_decreased():
	$Sort.get_child(-1).queue_free()


func on_distance_changed():
	pass


func _on_play_sounds_pressed():
	var sliders = []
	for point in get_tree().get_nodes_in_group('Point'):
		if point.type == 0:
			sliders.append(point)
	
	for s in sliders:
		s.check_touching()
