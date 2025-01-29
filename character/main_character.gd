extends "res://character/base_character.gd"

var dialog_npc: CharacterBody2D = null

var npc_dialogs_history: Dictionary = {}


func _ready():
	# TODO: add autogeneration size of ui and dialog window
	super._ready()
	#$UI.size = DisplayServer.window_get_size()
	$UI/DialogWindow.visible = false


func _physics_process(delta):
	if Input.is_action_just_pressed("activate_dialog"):
		_start_dialog()
		return

	var direction = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1

	if Input.is_action_pressed("move_left"):
		direction.x -= 1

	if Input.is_action_pressed("move_up"):
		direction.y -= 1

	if Input.is_action_pressed("move_down"):
		direction.y += 1

	if direction:
		_play_run_sprite_animation(direction)

		direction = direction.normalized()
		velocity = direction * SPEED
		move_and_slide()

	if Input.is_action_pressed("attack"):
		_start_attack(get_global_mouse_position())


func _start_dialog():
	if dialog_npc:
		$UI/DialogWindow.start_new_dialog(dialog_npc, npc_dialogs_history.get(dialog_npc.name, 1))


func deactivate_dialog():
	$UI/DialogWindow.deactivate_dialog()
