extends "res://character/base_character.gd"


func _physics_process(delta):
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

	if Input.is_action_pressed('attack'):
		_attack()


func _attack():

	var diff = get_global_mouse_position() - global_position

	print(diff)

	if diff.x >= 0 and diff.y <= 0:
		# top right
		_play_attack_sprite_animation(
			AttackSide.TOP if (abs(diff.y) > diff.x) else AttackSide.RIGHT
		)
	elif diff.x >= 0 and diff.y >= 0:
		# bottom right
		_play_attack_sprite_animation(
			AttackSide.BOTTOM if (diff.y > diff.x) else AttackSide.RIGHT
		)
	elif diff.x <= 0 and diff.y <= 0:
		# top left
		_play_attack_sprite_animation(
			AttackSide.TOP if (abs(diff.y) > abs(diff.x)) else AttackSide.LEFT
		)
	elif diff.x <= 0 and diff.y >= 0:
		# bottom left
		_play_attack_sprite_animation(
			AttackSide.BOTTOM if (diff.y > abs(diff.x)) else AttackSide.LEFT
		)
