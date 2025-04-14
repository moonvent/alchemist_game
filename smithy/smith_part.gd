extends Node2D

class_name SmithyPart

var is_dragging: bool = false

var drag_offset: Vector2  # Сохраним смещение между мышкой и нодой


func _ready() -> void:
	add_to_group("MovePart")


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

		# _panel_container.queue_redraw()

	elif event is InputEventMouseMotion and is_dragging:
		print(event.relative)
		if is_dragging:
			position += event.relative


func start_dragging():
	is_dragging = true


func stop_dragging():
	is_dragging = false
