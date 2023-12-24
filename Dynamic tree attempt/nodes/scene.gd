extends Node2D

var branch = preload("res://nodes/tree_branch.tscn")
onready var closest_branch = null
var closest_branch_dist = INF

onready var branch_nodes = []

var dr_pos = Vector2(0, -600)

var closest_branch_1 = null
var closest_branch_dist_1 = INF
var must_connect = false

func _draw() -> void:
	
	draw_arc(dr_pos, 8, -PI, PI, 360, Color.cyan, 1.0)
	if must_connect:
		draw_arc(closest_branch_1.position, 8, -PI, PI, 360, Color.white)
		
		
func get_closest_branch():
	
	closest_branch_dist = INF
	for i in branch_nodes:
		i.selected = false
		var dist = i.global_position.distance_squared_to(get_global_mouse_position())
		if dist < closest_branch_dist:
			if i.global_position.distance_squared_to(get_global_mouse_position()) < 5000:
				closest_branch = i
				closest_branch_dist = dist
			
var spwn_pos = Vector2.ZERO

func get_closest_branch_1():
	
	closest_branch_dist_1 = INF
	for i in branch_nodes:
		var dist = i.global_position.distance_squared_to(get_global_mouse_position())
		closest_branch_1 = i
		closest_branch_dist_1 = dist

var fx = preload("res://nodes/fx.tscn")

func explosion(pos):
	var inst = fx.instance()
	inst.position = pos
	add_child(inst)
	
func _physics_process(delta: float) -> void:
	update()
	
	if branch_nodes != []:
		if not Input.is_action_pressed("CLICK") and not Input.is_action_just_released("CLICK"):
			get_closest_branch()
			dr_pos = dr_pos.linear_interpolate(closest_branch.position, delta * 25)
		else:
			get_closest_branch_1()
			
	if closest_branch != null:
		
		if Input.is_action_pressed("CLICK"):
			closest_branch.selected = true
			
			if get_global_mouse_position().distance_squared_to(closest_branch_1.global_position) < 1500 and closest_branch_1 != closest_branch:
				must_connect = true
			else:
				must_connect = false

			
		if Input.is_action_just_released("CLICK"):
			if not must_connect:
				var node_inst = branch.instance()
				node_inst.position = closest_branch.position - (closest_branch.position - get_local_mouse_position()) / 3
				add_child(node_inst)
				closest_branch.branches.append(node_inst)
				
				closest_branch = node_inst
				branch_nodes.append(node_inst)
				explosion(node_inst.position)
			else:
				closest_branch_1.branches.append(closest_branch)
				must_connect = false
				explosion(closest_branch.position)
			
	else:
		if Input.is_action_just_pressed("CLICK"):
			var inst = branch.instance()
			inst.position = get_local_mouse_position()
			branch_nodes.append(inst)
			add_child(inst)
	
	if Input.is_action_just_pressed("ALTCLICK"):
		for i in branch_nodes:
			if i.global_position.distance_squared_to(get_global_mouse_position()) < 1500:
				i.branches.clear()
