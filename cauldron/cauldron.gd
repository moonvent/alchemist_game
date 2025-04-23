extends Control

class_name Cauldron


func _ready() -> void:
	find_child("Button").connect("pressed", find_child("PipeScheme").start_liquids)
