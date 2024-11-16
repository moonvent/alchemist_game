extends "res://character/base_character.gd"


func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var direction = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1

	if Input.is_action_pressed("move_left"):
		direction.x -= 1

	if Input.is_action_pressed("move_up"):
		direction.y -= 1

	if Input.is_action_pressed("move_down"):
		direction.y += 1

	if direction.y and direction.x:
		sprite.play("move_down" if direction.y == 1 else "move_up")
	elif direction.y:
		sprite.play("move_down" if direction.y == 1 else "move_up")
	elif direction.x:
		sprite.play("move_right" if direction.x == 1 else "move_left")
	else:
		sprite.stop()

	direction = direction.normalized()
	velocity = direction * SPEED
	move_and_slide()
