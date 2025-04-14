extends Control


func _ready() -> void:
	_make_all_child_movable()


func _make_all_child_movable():
	for child in get_tree().get_nodes_in_group("MovePart"):
		print(child)


func _make_moveable(part: Polygon2D):
	pass
