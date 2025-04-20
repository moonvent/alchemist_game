extends Polygon2D

class_name SmithyPart

var is_dragging: bool = false
var is_selected: bool = false

var drag_offset: Vector2  # Сохраним смещение между мышкой и нодой


func _ready() -> void:
	add_to_group("MovePart")
	add_to_group("RotatePart")


func _input(event):
	if event.is_action_pressed("select_smith_part"):
		# select / start srag / stop drag
		if Geometry2D.is_point_in_polygon(to_local(event.position), polygon):
			# check if selected current element
			if not is_selected:
				is_selected = true
			else:
				stop_dragging() if is_dragging else start_dragging()

	if is_selected:
		if is_dragging and event is InputEventMouseMotion:
			# its drugging process
			position += event.relative
		elif event.is_action_pressed("rotate_smith_part_right"):
			# rotate to right
			center_polygon_around_itself(self)
			rotation += deg_to_rad(45)
		elif event.is_action_pressed("rotate_smith_part_left"):
			# rotate to left
			center_polygon_around_itself(self)
			rotation -= deg_to_rad(45)


func start_dragging():
	is_dragging = true
	_change_signals_to_connect_state(true)


func stop_dragging():
	is_dragging = false
	_change_signals_to_connect_state(false)


func _enter_to_connect_area_part(new_area: Area2D, current_area: Area2D):
	if new_area.name == current_area.name:
		stop_dragging()
		global_position = new_area.global_position


func _change_signals_to_connect_state(activate: bool = true):
	for connection_area in get_children():
		var _connect_func = Callable(_enter_to_connect_area_part).bind(connection_area)
		if activate:
			connection_area.connect("area_entered", _connect_func)
		else:
			connection_area.disconnect("area_entered", _connect_func)


func center_polygon_around_itself(polygon_node: Polygon2D):
	var points = polygon_node.polygon
	var center = Vector2()

	for point in points:
		center += point
	center /= points.size()

	# Сдвигаем точки у Polygon2D
	for i in range(points.size()):
		points[i] -= center
	polygon_node.polygon = points

	# Сдвигаем саму ноду, чтобы визуально не изменилось
	polygon_node.position += center

	# Теперь ищем CollisionPolygon2D и сдвигаем его polygon тоже!
	for child in polygon_node.get_children():
		if child is Area2D:
			for area_child in child.get_children():
				if area_child is CollisionPolygon2D:
					var shape_points = area_child.polygon
					for i in range(shape_points.size()):
						shape_points[i] -= center
					area_child.polygon = shape_points
