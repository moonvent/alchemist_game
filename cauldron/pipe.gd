extends Node2D

class_name Pipe

enum Puts { UP, RIGHT, DOWN, LEFT }

var _active_puts: Array = []  # array[puts]
var active_puts: Array:
	get:
		return _active_puts
	set(value):
		_set_active_puts(value)

var input_pipe: Pipe
var output_pipe: Pipe

var _pipe_number: int

var _is_contain_in_schema: bool = false
@export var is_contain_in_schema: bool:
	get:
		return _is_contain_in_schema
	set(value):
		_is_contain_in_schema = value
		self.visible = value

var is_end_pipe: bool = false


func _ready():
	visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select_smith_part"):
		# rotate pipe
		var local_mouse = $Polygon2D.to_local(get_global_mouse_position())
		if Geometry2D.is_point_in_polygon(local_mouse, $Polygon2D.polygon):
			pipe_rotate()


func pipe_rotate():
	rotation += deg_to_rad(90)
	_rotate_active_puts()


func _rotate_active_puts():
	for i in _active_puts:
		pass


func _set_active_puts(active_puts_array: Array):
	_pipe_number = name.to_int()

	var output_pipe_number: int

	for put in active_puts_array:
		match put:
			Puts.UP:
				output_pipe_number = _pipe_number - 10
				$Puts/Up.visible = true
			Puts.RIGHT:
				output_pipe_number = _pipe_number + 1
				$Puts/Right.visible = true
			Puts.DOWN:
				output_pipe_number = _pipe_number + 10
				$Puts/Down.visible = true
			Puts.LEFT:
				output_pipe_number = _pipe_number - 1
				$Puts/Left.visible = true
		_active_puts.append(get_parent().get_node("Pipe" + str(output_pipe_number)))
