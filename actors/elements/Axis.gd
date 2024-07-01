
@tool
extends Node2D


var thickness = 2.0
var line_color = Color.WHITE

func _physics_process(delta):
	pass


func _draw():
	draw_line(Vector2(0, -1000), Vector2(0, 1000), line_color, thickness)
	draw_line(Vector2(-1000, 0), Vector2(1000, 0), line_color, thickness)
