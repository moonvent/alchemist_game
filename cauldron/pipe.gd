extends Node2D

class_name Pipe

enum Puts { UP, RIGHT, DOWN, LEFT }

var liquids_array: Array[Liquid]

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


func can_enter_in_new_pipe(new_pipe, old_put: Puts) -> bool:
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
		await run_liquid(old_put, interest_put, new_pipe)
		return true

	await run_liquid_dead_end(old_put)
	return false


func _make_color_texture(color: Color, bar: TextureProgressBar):
	var img := Image.create(bar.size.x, bar.size.y, false, Image.FORMAT_RGBA8)
	img.fill(color)
	bar.texture_progress = ImageTexture.create_from_image(img)


func run_liquid(old_put: Puts, new_put: Puts, new_pipe: Pipe):
	var from_progress_bar: TextureProgressBar
	var to_progress_bar: TextureProgressBar
	var fill_mode: ProgressBar.FillMode

	match old_put:
		Puts.UP:
			from_progress_bar = find_child("UpProgressBar")
			to_progress_bar = new_pipe.find_child("DownProgressBar")
			fill_mode = ProgressBar.FillMode.FILL_BOTTOM_TO_TOP
		Puts.RIGHT:
			from_progress_bar = find_child("RightProgressBar")
			to_progress_bar = new_pipe.find_child("LeftProgressBar")
			fill_mode = ProgressBar.FillMode.FILL_BEGIN_TO_END
		Puts.DOWN:
			from_progress_bar = find_child("DownProgressBar")
			to_progress_bar = new_pipe.find_child("UpProgressBar")
			fill_mode = ProgressBar.FillMode.FILL_TOP_TO_BOTTOM
		Puts.LEFT:
			from_progress_bar = find_child("LeftProgressBar")
			to_progress_bar = new_pipe.find_child("RightProgressBar")
			fill_mode = ProgressBar.FillMode.FILL_END_TO_BEGIN

	from_progress_bar.visible = true
	_make_color_texture(Color.ORANGE, from_progress_bar)
	from_progress_bar.texture_under = null
	from_progress_bar.set_fill_mode(fill_mode)

	to_progress_bar.visible = true
	_make_color_texture(Color.ORANGE, to_progress_bar)
	to_progress_bar.texture_under = null
	to_progress_bar.set_fill_mode(fill_mode)

	var tween = create_tween()
	tween.tween_property(from_progress_bar, "value", 4, 0.5)
	await tween.finished
	tween = create_tween()
	tween.tween_property(to_progress_bar, "value", 4, 0.5)
	await tween.finished


func run_liquid_dead_end(old_put: Puts):
	var from_progress_bar: TextureProgressBar
	var fill_mode: ProgressBar.FillMode
	match old_put:
		Puts.UP:
			from_progress_bar = find_child("UpProgressBar")
			fill_mode = ProgressBar.FillMode.FILL_BOTTOM_TO_TOP
		Puts.RIGHT:
			from_progress_bar = find_child("RightProgressBar")
			fill_mode = ProgressBar.FillMode.FILL_BEGIN_TO_END
		Puts.DOWN:
			from_progress_bar = find_child("DownProgressBar")
			fill_mode = ProgressBar.FillMode.FILL_TOP_TO_BOTTOM
		Puts.LEFT:
			from_progress_bar = find_child("LeftProgressBar")
			fill_mode = ProgressBar.FillMode.FILL_END_TO_BEGIN

	from_progress_bar.visible = true
	from_progress_bar.set_fill_mode(fill_mode)

	var tween := create_tween()
	tween.tween_property(from_progress_bar, "value", 4, 0.5)
	await tween.finished
