extends Node2D

class_name Sewing


func _ready():
	$Button.connect("pressed", _start_cutting)


func _start_cutting():
	pass
	# print(get_polygon_area($Polygon2D.polygon))
