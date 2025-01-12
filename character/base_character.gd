extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

var SPEED = 75.0
const JUMP_VELOCITY = -400.0

var health_points = 10
var primary_sword_damage_per_collider = 0.25

var is_attacking = false

var is_dead = false

enum AttackSide {
	UP,
	LEFT,
	DOWN,
	RIGHT,
}

var collision_attack: Node2D = null


func _ready():
	_setup_attack_collisions()


func die():
	is_dead = true
	set_collision_layer(2)
	set_collision_mask(2)


func make_damage(damage_points: float):
	health_points -= damage_points
	print(health_points)

	if health_points == 0:
		die()


func _on_attack_collider_body_entered(body):
	if body != self and body is CharacterBody2D:
		body.make_damage(primary_sword_damage_per_collider)


func _setup_attack_collisions():
	var attack_colliders_list = [
		$Collisions/Attack/Up,
		$Collisions/Attack/Left,
		$Collisions/Attack/Down,
		$Collisions/Attack/Right,
	]
	for collider in attack_colliders_list:
		for one_attack_frame in collider.get_children():
			one_attack_frame.connect("body_entered", _on_attack_collider_body_entered)


func _play_run_sprite_animation(direction: Vector2):
	if not is_attacking:
		direction.x = round(direction.x)
		direction.y = round(direction.y)

		if direction.x != 0 and direction.y != 0:
			sprite.play("move_down" if direction.y > 0 else "move_up")

		elif direction.y != 0:
			sprite.play("move_down" if direction.y > 0 else "move_up")

		elif direction.x != 0:
			sprite.play("move_right" if direction.x > 0 else "move_left")


func _play_attack_sprite_animation(attack_side: AttackSide):
	match attack_side:
		AttackSide.UP:
			sprite.play("attack_up")
			collision_attack = $Collisions/Attack/Up
		AttackSide.LEFT:
			sprite.play("attack_left")
			collision_attack = $Collisions/Attack/Left
		AttackSide.DOWN:
			sprite.play("attack_down")
			collision_attack = $Collisions/Attack/Down
		AttackSide.RIGHT:
			sprite.play("attack_right")
			collision_attack = $Collisions/Attack/Right


func _attack(attack_position_point: Vector2):
	var diff = attack_position_point - global_position

	var attack_direction: AttackSide

	if diff.x >= 0 and diff.y <= 0:
		# top right
		attack_direction = AttackSide.UP if (abs(diff.y) > diff.x) else AttackSide.RIGHT

	elif diff.x >= 0 and diff.y >= 0:
		# bottom right
		attack_direction = AttackSide.DOWN if (diff.y > diff.x) else AttackSide.RIGHT

	elif diff.x <= 0 and diff.y <= 0:
		# top left
		attack_direction = AttackSide.UP if (abs(diff.y) > abs(diff.x)) else AttackSide.LEFT

	elif diff.x <= 0 and diff.y >= 0:
		# bottom left
		attack_direction = AttackSide.DOWN if (diff.y > abs(diff.x)) else AttackSide.LEFT

	_play_attack_sprite_animation(attack_direction)


func _on_animated_sprite_2d_animation_finished():
	# need to setup argument about animation which finish for stop moving in enemy for example
	var current_animation = sprite.animation

	if is_attacking and current_animation.begins_with("attack_"):
		_activate_attack_collider(-1)
		_stop_attack()


func _on_animated_sprite_2d_frame_changed():
	if sprite and collision_attack:
		var current_frame_number = sprite.frame
		if current_frame_number == 3:
			current_frame_number = 2
		if current_frame_number == 4:
			current_frame_number = 0
		_activate_attack_collider(current_frame_number)


func _start_attack(attack_position_point: Vector2):
	if not is_attacking:
		is_attacking = true  # make one attack for a little period
		_attack(attack_position_point)


func _stop_attack():
	is_attacking = false


func _activate_attack_collider(collider_index: int):
	var is_disable_collider: int = 1

	for collision_frame_area_number in range(collision_attack.get_child_count()):
		if collider_index == -1:
			is_disable_collider = 1
		else:
			is_disable_collider = collision_frame_area_number != collider_index

		collision_attack.get_child(collision_frame_area_number).get_child(0).disabled = (is_disable_collider)
