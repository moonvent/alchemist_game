extends Node2D

class_name PipeScheme

var current_schema: PipeDirectionSchema

var _primary_pipes: Array[Pipe]

var _current_run_pipes: Array[Pipe]


func _ready():
	_set_pipe_schema()
	# start_liquids()


func _set_pipe_schema():
	current_schema = FirstPipeDirectionSchema.new()

	for pipe_number in current_schema.active_pipes:
		get_node("Pipe" + str(pipe_number)).is_contain_in_schema = true

	for pipe_name in current_schema.default_pipe_directions.keys():
		get_node(pipe_name).active_puts = current_schema.default_pipe_directions[pipe_name]

	_setup_lines_on_schema()


func _setup_lines_on_schema():
	var start_pipe: Pipe

	for schema_liquid in current_schema.liquids_array:
		start_pipe = get_node(schema_liquid.start_pipe_name)
		start_pipe.is_start_pipe = true
		_primary_pipes.append(start_pipe)

		get_node(schema_liquid.end_pipe_name).is_end_pipe = true


func start_liquids():
	print("start liquids")
	_current_run_pipes = _primary_pipes.duplicate()

	for active_pipe in _current_run_pipes:
		process_liquid(active_pipe)


func process_liquid(current_pipe: Pipe):
	print("Now in:", current_pipe.name)
	if current_pipe.is_end_pipe:
		print("Grats")
		return

	var next_pipe: Pipe
	if current_pipe.is_start_pipe:
		next_pipe = _get_next_pipe(current_pipe, current_pipe.active_puts[0])
	else:
		next_pipe = _get_next_pipe(current_pipe, current_pipe.output_put)

	if next_pipe:
		_current_run_pipes.append(next_pipe)
	else:
		print("Last connected pipe: ", current_pipe.name)


func _get_next_pipe(current_pipe: Pipe, put: Pipe.Puts):
	var new_pipe_number = current_pipe.get_next_pipe_number(put)
	if new_pipe_number:
		var new_pipe = get_node("Pipe" + str(new_pipe_number))
		if current_pipe.can_enter_in_new_pipe(new_pipe, put):
			return new_pipe
