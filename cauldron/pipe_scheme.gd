extends Node2D

class_name PipeScheme

var current_schema: PipeDirectionSchema


func _ready():
	_set_pipe_schema()
	start_liquid()


func _set_pipe_schema():
	current_schema = FirstPipeDirectionSchema.new()

	for pipe_number in current_schema.active_pipes:
		get_node("Pipe" + str(pipe_number)).is_contain_in_schema = true

	get_node(current_schema.start_pipe_name).is_start_pipe = true
	get_node(current_schema.finish_pipe_name).is_end_pipe = true

	for pipe_name in current_schema.default_pipe_directions.keys():
		get_node(pipe_name).active_puts = current_schema.default_pipe_directions[pipe_name]


func start_liquid():
	var start_pipe = get_node(current_schema.start_pipe_name)
	var liquid = Liquid.new(AspectsWorker.aspects["fire"], start_pipe, Pipe.Puts.RIGHT)

	var timer = Timer.new()
	timer.wait_time = 5.0
	timer.one_shot = true
	add_child(timer)  # обязательно добавить в дерево сцены

	timer.connect("timeout", Callable(process_liquid).bind(start_pipe, liquid))
	timer.start()

	# process_liquid(start_pipe, liquid)


func process_liquid(current_pipe: Pipe, liquid: Liquid):
	print("Now in:", current_pipe.name)
	if current_pipe.is_end_pipe:
		print("Grats")
		return
	var next_pipe: Pipe
	if current_pipe.name == current_schema.start_pipe_name:
		next_pipe = _get_next_pipe(current_pipe, current_pipe.active_puts[0])
	else:
		next_pipe = _get_next_pipe(current_pipe, current_pipe.output_put)

	if next_pipe:
		return process_liquid(next_pipe, liquid)
	else:
		print("Last connected pipe: ", current_pipe.name)


func _get_next_pipe(current_pipe: Pipe, put: Pipe.Puts):
	var new_pipe_number = current_pipe.get_next_pipe_number(put)
	if new_pipe_number:
		var new_pipe = get_node("Pipe" + str(new_pipe_number))
		if current_pipe.can_enter_in_new_pipe(new_pipe, put):
			return new_pipe
