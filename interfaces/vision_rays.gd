extends Node2D

var _vision_rays_list: Array

var _main_node: CharacterBody2D  # it's a parent node, character body


func _ready():
	_vision_rays_list = get_children()


func set_main_node(main_node: CharacterBody2D):
	_main_node = main_node


func scan_near_location(target: CharacterBody2D = null):
	for ray in _vision_rays_list:
		if ray.is_colliding():
			var collider = ray.get_collider()
			if collider != _main_node and (collider == target or collider is CharacterBody2D):
				return collider


func switch_enable_status(status: bool):
	for ray in _vision_rays_list:
		ray.enabled = status
