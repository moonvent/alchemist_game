extends Node2D

var _vision_rays_list: Array


func _ready():
	_vision_rays_list = get_children()


func scan_near_location():
	for ray in _vision_rays_list:
		if ray.is_colliding():
			var collider = ray.get_collider()
			if collider is CharacterBody2D:
				return collider
