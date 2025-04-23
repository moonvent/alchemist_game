extends Node2D

class_name Pipe

enum Puts { UP, RIGHT, DOWN, LEFT }

var _active_puts: Array = []  # array[puts]
var active_puts: Array:
	get:
		return _active_puts
	set(value):
		_set_active_puts(value)

var pipe_number: int

var _input_put: Puts
var input_put: Puts:
	get:
		return _input_put
	set(value):
		_input_put = value

		if not is_end_pipe:
			_output_put = _active_puts[0 if _active_puts.find(value) == 1 else 1]

var _output_put: Puts
var output_put: Puts:
	get:
		return _output_put
	set(value):
		_output_put = value

var _is_contain_in_schema: bool = false
@export var is_contain_in_schema: bool:
	get:
		return _is_contain_in_schema
	set(value):
		_is_contain_in_schema = value
		self.visible = value

var is_start_pipe: bool = false
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
	_rotate_active_puts()


func _rotate_active_puts():
	var new_acitve_puts = []
	_active_puts.reverse()
	for put in _active_puts:
		match put:
			Puts.UP:
				new_acitve_puts.append(Puts.RIGHT)
				$Puts/Up.visible = false
				$Puts/Right.visible = true
			Puts.RIGHT:
				new_acitve_puts.append(Puts.DOWN)
				$Puts/Right.visible = false
				$Puts/Down.visible = true
			Puts.DOWN:
				new_acitve_puts.append(Puts.LEFT)
				$Puts/Down.visible = false
				$Puts/Left.visible = true
			Puts.LEFT:
				new_acitve_puts.append(Puts.UP)
				$Puts/Left.visible = false
				$Puts/Up.visible = true
	new_acitve_puts.reverse()
	_active_puts = new_acitve_puts


func _set_active_puts(active_puts_array: Array):
	pipe_number = name.to_int()

	var output_pipe_number: int

	for put in active_puts_array:
		match put:
			Puts.UP:
				# output_pipe_number = _pipe_number - 10
				$Puts/Up.visible = true
			Puts.RIGHT:
				# output_pipe_number = _pipe_number + 1
				$Puts/Right.visible = true
			Puts.DOWN:
				# output_pipe_number = _pipe_number + 10
				$Puts/Down.visible = true
			Puts.LEFT:
				# output_pipe_number = _pipe_number - 1
				$Puts/Left.visible = true
		# _active_puts.append(get_parent().get_node("Pipe" + str(output_pipe_number)))
		_active_puts.append(put)


func get_next_pipe_number(put: Puts) -> int:
	match put:
		Puts.UP:
			return pipe_number - 10
		Puts.RIGHT:
			return pipe_number + 1
		Puts.DOWN:
			return pipe_number + 10
		Puts.LEFT:
			return pipe_number - 1
	return 0


func can_enter(new_pipe, old_put: Puts):
	var interest_put: Puts
	match old_put:
		Puts.UP:
			interest_put = Puts.DOWN
		Puts.RIGHT:
			interest_put = Puts.LEFT
		Puts.DOWN:
			interest_put = Puts.UP
		Puts.LEFT:
			interest_put = Puts.RIGHT

	if interest_put in new_pipe.active_puts:
		new_pipe.input_put = interest_put
		return true
