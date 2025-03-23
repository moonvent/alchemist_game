extends "res://character/base_character.gd"

class_name Player

var dialog_npc: BaseCharacter = null
var previous_position: Vector2

var attributes: Dictionary


func _ready():
	# TODO: add autogeneration size of ui and dialog window
	super._ready()
	$UI/DialogWindow.visible = false
	#conditions[Attributes.SpawnInTheGame] = "1"
	attributes = {}


func _physics_process(delta):
	previous_position = position

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
		velocity = (
			direction * AttributeWorker.get_attribute_value(name, Attribute.AttributeName.MoveSpeed)
		)
		move_and_slide()

		WorldListenerCore.emit_event(
			WorldListenerCore.PlayerMoveEvent.new(position.distance_to(previous_position))
		)

	if Input.is_action_pressed("attack"):
		_start_attack(get_global_mouse_position())


func _start_dialog():
	if dialog_npc:
		if not $UI/DialogWindow.visible:
			$UI/DialogWindow.start_new_dialog(
				dialog_npc, conditions.get(dialog_npc.name + "__last_dialog_number", 1)
			)
		else:
			deactivate_dialog()


func deactivate_dialog():
	$UI/DialogWindow.deactivate_dialog()
