extends PipeDirectionSchema

class_name FirstPipeDirectionSchema


func _init():
	start_pipe_name = "Pipe1"
	finish_pipe_name = "Pipe25"
	active_pipes = range(1, 8) + range(11, 18) + range(20, 27) + range(33, 38)
	default_pipe_directions = {
		"Pipe1":
		[
			put_alias.RIGHT,
		],
		"Pipe2":
		[
			put_alias.UP,
			put_alias.DOWN,
		],
		"Pipe3":
		[
			put_alias.UP,
			put_alias.DOWN,
		],
		"Pipe4":
		[
			put_alias.UP,
			put_alias.DOWN,
		],
		"Pipe5":
		[
			put_alias.UP,
			put_alias.RIGHT,
		],
		"Pipe15":
		[
			put_alias.RIGHT,
			put_alias.LEFT,
		],
		"Pipe25":
		[
			put_alias.RIGHT,
		],
	}
