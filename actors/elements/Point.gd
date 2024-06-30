extends Node2D


enum TYPE{
	POINT,
	STATION
}

var type = TYPE.POINT
var sound = ''

var is_dragging = false



func _ready():
	match type:
		TYPE.STATION: $Inner/Circle.texture = load("res://art/circle.png")


func _physics_process(delta):
	if is_dragging:
		look_at(get_global_mouse_position())


func _unhandled_input(event):
	if is_dragging and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_dragging = false
 

func play_sound():
	pass


func check_touching():
	if type == TYPE.POINT:
		for a in $Inner/Area2D.get_overlapping_areas():
			a.get_parent().get_parent()._on_area_2d_area_entered(null)


func _on_area_2d_area_entered(area):
	if type == TYPE.STATION:
		Sfx.play_sound(sound)


func _on_area_2d_area_exited(area):
	pass # Replace with function body.


func _on_area_2d_input_event(viewport, event, shape_idx):
	if type != TYPE.POINT:
		return
	
	if is_dragging == false and event is InputEventMouse and event.button_mask == MOUSE_BUTTON_MASK_LEFT and event.is_pressed():
		is_dragging = true
