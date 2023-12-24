extends Node2D

var selected = false
var branches = []
var ms_pos = Vector2.ZERO

onready var starting_pos = position
var vel = Vector2.ZERO

var tex = preload("res://pixel.png")

func _draw() -> void:
	draw_arc(Vector2.ZERO, 6, -PI, PI, 360, Color.white, 1.0)
	if selected:
		draw_line(ms_pos.normalized() * 10, ms_pos, Color.cyan, 1.0)
		
	for i in branches:
		vel += (i.position - position) 
		draw_line((i.position - position).normalized() * 10, (i.position - position) - (i.position - position).normalized() * 10, Color.white, 1.0)
	
func _physics_process(delta: float) -> void:
	position += vel * delta
	vel *= 0.7
	vel += (starting_pos - position) 
#	position.y += sin((OS.get_ticks_msec() + position.x * 1000) * delta) * 1
	if selected:
		ms_pos = get_local_mouse_position() / 3
		
		
	update()
		
