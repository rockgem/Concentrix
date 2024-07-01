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

@onready var center = $Center

var sustain_sounds = false

func _ready():
	ManagerGame.world_ref = self
	
	circles_count_increased.connect(on_circles_count_increased)
	circles_count_decreased.connect(on_circles_count_decreased)
	distance_changed.connect(on_distance_changed)
	
	add_circles(circles_count)
	#add_station_to_circle(1, 1, 36.0, 655, 'square', Color.GREEN, .34)
	#add_station_to_circle(1, 1, 240.0, 400, 'circle', Color.BLUE, .48)
	#add_station_to_circle(2, 1, 89.0, 300, 'circle')
	#add_station_to_circle(3, 1, 89.0, 300, 'triangle', Color.RED)
	
	change_background_color(Color.BLACK)
	
	var count = 1
	for circle in $Sort.get_children():
		for i in 12:
			#add_station_to_circle(count, 1, i * PI / 6, 655, 'circle', Color.SKY_BLUE)
			add_station_to_circle(count, 1, -i * PI / 6, 655, 'circle', Color.SKY_BLUE, .32, 'Sound%s_%s' % [count, i])
		
		count += 1
	
	
	#change_circle_slider(1, 'triangle')
	#change_circle_slider(2, 'circle_small', Color.BLUE_VIOLET)


func delete_all():
	for child in $Sort.get_children():
		child.queue_free()


func add_circles(amount):
	var d = $Sort.get_child_count() * distance
	
	for i in range(amount):
		var c = load("res://actors/Circle.tscn").instantiate()
		c.length += d
		c.position = center.position
		
		$Sort.add_child(c)
		
		d += distance
		
		var obj = load("res://actors/elements/Point.tscn").instantiate()
		obj.type = 0
		obj.z_index = 99
		c.add_object(obj)


func add_station_to_circle(idx, amount = 1, rot = 0.0, sound_hz = 48.0, shape = 'circle', shape_color: Color = Color.WHITE, size = 0.32, sound_name: String = ''):
	var circle = $Sort.get_child(idx - 1)
	
	if circle == null:
		print('no circle in that index!')
		return
	else:
		for i in amount:
			var station = load("res://actors/elements/Point.tscn").instantiate()
			station.type = 1
			station.sound_hz = sound_hz
			station.sound_name = sound_name
			station.get_node('Inner/Circle').texture = load("res://art/%s.png" % shape)
			station.get_node('Inner/Circle').modulate = shape_color
			station.get_node('Inner/Circle').scale = Vector2(size, size)
			
			circle.add_object(station, rot)


func change_circle_slider(idx, shape = 'circle', color: Color = Color.WHITE, size = .32):
	var circle = $Sort.get_child(idx - 1)
	
	if circle == null:
		print('no circle in that index!')
		return
	else:
		var slider
		var arr = circle.get_children()
		
		for c in arr:
			if c.type == 0:
				slider = c
				break
		
		slider.get_node('Inner/Circle').texture = load("res://art/%s.png" % shape)
		slider.get_node('Inner/Circle').modulate = color
		slider.get_node('Inner/Circle').scale = Vector2(size, size)


func change_background_color(color):
	$CanvasLayer/Background.color = color


func generate_display(triangle_line):
	var display = load("res://actors/CircleDataDisplay.tscn").instantiate()
	display.triangle_line = triangle_line
	
	$CanvasLayer/Display/DisplayBox.add_child(display)


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


func _on_show_axis_toggled(toggled_on):
	if toggled_on:
		var axis = load("res://actors/elements/Axis.tscn").instantiate()
		axis.position = center.position
		add_child(axis)
		
		for slider in ManagerGame.get_sliders():
			var tl = load("res://actors/elements/TriangleLine.tscn").instantiate()
			tl.target = slider.get_node('Inner')
			tl.center = center
			add_child(tl)
			
			generate_display(tl)
		
	else:
		var axis = get_tree().get_nodes_in_group('Axis')[0]
		axis.queue_free()
		
		var tl = get_tree().get_nodes_in_group('TriangleLine')
		for t in tl:
			t.queue_free()
		
		for display in $CanvasLayer/Display/DisplayBox.get_children():
			display.queue_free()


func _on_sustain_sounds_toggled(toggled_on):
	sustain_sounds = toggled_on


func _on_save_pressed():
	pass # Replace with function body.


func _on_show_cons_toggled(toggled_on):
	if toggled_on:
		var sliders = ManagerGame.get_sliders()
		
		var count = 0
		for slider in sliders.size() - 1:
			var line = load("res://actors/elements/MonoLine.tscn").instantiate()
			line.target = sliders[count + 1].get_node('Inner')
			line.center = sliders[count].get_node('Inner')
			add_child(line)
			
			count += 1
	else:
		var mono = get_tree().get_nodes_in_group('MonoLine')
		for t in mono:
			t.queue_free()
