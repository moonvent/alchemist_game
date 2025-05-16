extends Node2D

class_name FabricPiece

enum Direction { LeftTop, RightTop, RightDown, LeftDown }

var move_point: int = -1
# here we hold button name to point index
var button_to_point: Dictionary[Direction, Vector2] = {}
var corner_button_center: Vector2

var max_polygon_area: float = 20000
var min_polygon_area: float = 10000

var last_correct_point: Vector2
var is_move_point: bool = false


func _ready():
	$Polygon2D/LeftTopCorner.connect(
		"button_down", Callable(_start_moving_point).bind(Direction.LeftTop)
	)
	$Polygon2D/RightTopCorner.connect(
		"button_down", Callable(_start_moving_point).bind(Direction.RightTop)
	)
	$Polygon2D/RightDownCorner.connect(
		"button_down", Callable(_start_moving_point).bind(Direction.RightDown)
	)
	$Polygon2D/LeftDownCorner.connect(
		"button_down", Callable(_start_moving_point).bind(Direction.LeftDown)
	)

	$Polygon2D/LeftTopCorner.connect("button_up", _button_up)
	$Polygon2D/RightTopCorner.connect("button_up", _button_up)
	$Polygon2D/RightDownCorner.connect("button_up", _button_up)
	$Polygon2D/LeftDownCorner.connect("button_up", _button_up)

	corner_button_center = $Polygon2D/LeftDownCorner.size * 0.5

	button_to_point[Direction.LeftTop] = $Polygon2D.polygon[0]
	button_to_point[Direction.RightTop] = $Polygon2D.polygon[1]
	button_to_point[Direction.RightDown] = $Polygon2D.polygon[2]
	button_to_point[Direction.LeftDown] = $Polygon2D.polygon[3]


func _start_moving_point(corner: Direction):
	is_move_point = true
	move_point = button_to_point.keys().find(corner)


func _button_up():
	is_move_point = false


func _input(event):
	if event is InputEventMouseMotion and is_move_point:
		var current_polygon_area = get_polygon_area()
		var new_point: Vector2

		if current_polygon_area < min_polygon_area or current_polygon_area > max_polygon_area:
			new_point = last_correct_point
			is_move_point = false

		else:
			new_point = get_local_mouse_position()
			if current_polygon_area > min_polygon_area:
				last_correct_point = new_point

		$Polygon2D.polygon[move_point] = new_point
		$Polygon2D.get_children()[move_point].position = new_point - corner_button_center


func get_polygon_area() -> float:
	var polygon: Array = $Polygon2D.polygon
	var area := 0.0
	var n := polygon.size()
	for i in range(n):
		var current = polygon[i]
		var next = polygon[(i + 1) % n]
		area += (current.x * next.y) - (next.x * current.y)
	return abs(area) * 0.5
