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

	get_node(current_schema.finish_pipe_name).is_end_pipe = true

	for pipe_name in current_schema.pipe_directions.keys():
		get_node(pipe_name).active_puts = current_schema.pipe_directions[pipe_name]


func start_liquid():
	var start_pipe = get_node(current_schema.start_pipe_name)
	var liquid = Liquid.new(AspectsWorker.aspects["fire"], start_pipe, Pipe.Puts.RIGHT)
	process_liquid(start_pipe, liquid)


func process_liquid(current_pipe: Pipe, liquid: Liquid):
	print(current_pipe.name)
	if current_pipe.is_end_pipe:
		print("Grats")
	elif current_pipe.output_pipe:
		process_liquid(current_pipe.output_pipe, liquid)
