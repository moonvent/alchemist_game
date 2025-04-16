extends Polygon2D

class_name SmithyPart

var is_dragging: bool = false
var is_selected: bool = false

var drag_offset: Vector2  # Сохраним смещение между мышкой и нодой


func _ready() -> void:
	add_to_group("MovePart")
	add_to_group("RotatePart")


func _input(event):
	# check if selected current element
	if Geometry2D.is_point_in_polygon(to_local(event.position), polygon):
		if event.is_action_pressed("select_smith_part"):
			if not is_selected:
				is_selected = true
			else:
				stop_dragging() if is_dragging else start_dragging()

		elif is_dragging and is_selected and event is InputEventMouseMotion:
			position += event.relative


func start_dragging():
	is_dragging = true
	_change_signals_to_connect_state(true)


func stop_dragging():
	is_dragging = false
	_change_signals_to_connect_state(false)


func _enter_to_connect_area_part(self_area: Area2D, connect_area: Area2D):
	if self_area.name == connect_area.name:
		stop_dragging()
		global_position = self_area.global_position


func _change_signals_to_connect_state(activate: bool = true):
	for connection_area in get_children():
		var _connect_func = Callable(_enter_to_connect_area_part).bind(connection_area)
		if activate:
			connection_area.connect("area_entered", _connect_func)
		else:
			connection_area.disconnect("area_entered", _connect_func)
