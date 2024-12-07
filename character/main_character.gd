extends "res://character/base_character.gd"


func _ready():
	super._ready()
	set_collision_layer(1)
	set_collision_mask(2)

	_setup_attack_collisions(3, 2)


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

	if Input.is_action_pressed("attack"):
		_start_attack(get_global_mouse_position())
