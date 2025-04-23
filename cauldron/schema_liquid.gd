class_name SchemaLiquid

var liquid: Liquid

var start_pipe_name: String
var end_pipe_name: String


func _init(_liquid: Liquid, _start_pipe_name: String, _end_pipe_name: String):
	liquid = _liquid
	start_pipe_name = _start_pipe_name
	end_pipe_name = _end_pipe_name
