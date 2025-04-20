extends Node2D

class_name SmithPart

var is_dragging: bool = false
var is_selected: bool = false

var drag_offset: Vector2  # Сохраним смещение между мышкой и нодой

var _smith_model: SmithModel

@export var correct_rotation_degrees: int


func _ready() -> void:
	add_to_group("MovePart")
	add_to_group("RotatePart")
	_smith_model = get_parent()


func _input(event):
	if event.is_action_pressed("select_smith_part"):
		# select / start srag / stop drag
		var local_mouse = $Polygon2D.to_local(get_global_mouse_position())
		if Geometry2D.is_point_in_polygon(local_mouse, $Polygon2D.polygon):
			# check if selected current element
			if not is_selected:
				_smith_model.switch_select_part(self)
			else:
				stop_dragging() if is_dragging else start_dragging()

	if is_selected:
		if is_dragging and event is InputEventMouseMotion:
			# its drugging process
			position += event.relative
		elif event.is_action_pressed("rotate_smith_part_right"):
			# rotate to right
			rotation += deg_to_rad(45)
		elif event.is_action_pressed("rotate_smith_part_left"):
			# rotate to left
			rotation -= deg_to_rad(45)


func start_dragging():
	is_dragging = true
	_change_signals_to_connect_state(true)


func stop_dragging():
	is_dragging = false
	_change_signals_to_connect_state(false)


func _enter_to_connect_area_part(new_area: Area2D, current_area: Area2D):
	if new_area.name == current_area.name and correct_rotation_degrees == int(rotation_degrees):
		stop_dragging()
		global_position = new_area.get_node("PartPosition").global_position


func _change_signals_to_connect_state(activate: bool = true):
	for connection_area in get_children():
		var _connect_func = Callable(_enter_to_connect_area_part).bind(connection_area)
		if activate:
			connection_area.connect("area_entered", _connect_func)
		else:
			connection_area.disconnect("area_entered", _connect_func)
