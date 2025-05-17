extends Node2D

class_name Sewing

var move_piece: FabricPiece


func _ready():
	$Button.connect("pressed", _start_cutting)


func _start_cutting():
	pass


func _start_moving_piece(piece: FabricPiece):
	move_piece = piece


func _stop_moving_piece():
	move_piece = null


func _input(event):
	if event is InputEventMouseMotion and move_piece:
		move_piece.position = get_local_mouse_position()
