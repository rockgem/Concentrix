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
	add_station_to_circle(1, 1, 36.0, 'Beep2')
	add_station_to_circle(1, 1, 240.0, 'Beep')
	add_station_to_circle(2, 1, 89.0, 'Beep')
	
	change_background_color(Color.YELLOW_GREEN)


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
		c.add_object(obj)


func add_station_to_circle(idx, amount = 1, rot = 0.0, sound = 'Beep'):
	var circle = $Sort.get_child(idx - 1)
	
	if circle == null:
		print('no circle in that index!')
		return
	else:
		for i in amount:
			var station = load("res://actors/elements/Point.tscn").instantiate()
			station.type = 1
			station.sound = sound
			
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
