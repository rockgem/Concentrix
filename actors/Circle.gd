@tool
extends Node2D

signal length_changed


@export var length = 90.0 :
	set(value):
		length = value
		
		length_changed.emit()


func _ready():
	length_changed.connect(on_length_update)


func _draw():
	draw_arc(Vector2.ZERO, length, 0, PI * 2, 100, Color.WHITE, 1.0, true)


func add_object(instance, rot = 0.0):
	instance.get_node('Inner').position.x = length
	instance.rotation = rot
	
	add_child(instance)


func on_length_update():
	for child in get_children():
		child.position.x = length


