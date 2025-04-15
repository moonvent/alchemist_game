extends Node2D

class_name SmithyPart

var is_dragging: bool = false

var drag_offset: Vector2  # Сохраним смещение между мышкой и нодой


func _ready() -> void:
	add_to_group("MovePart")
	for connection_area in get_tree().get_nodes_in_group("ConnectionArea"):
		connection_area.connect(
			"area_entered", Callable(_enter_to_connect_area_part).bind(connection_area)
		)


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if (
				event.pressed
				and Geometry2D.is_point_in_polygon(to_local(event.position), $PartPolygon.polygon)
			):
				start_dragging()

			else:
				stop_dragging()

	elif event is InputEventMouseMotion and is_dragging:
		if is_dragging:
			position += event.relative / global_scale


func start_dragging():
	is_dragging = true


func stop_dragging():
	is_dragging = false


func _enter_to_connect_area_part(entered_area: Area2D, area: Area2D):
	if entered_area.name == area.name:
		stop_dragging()
		position = entered_area.position
