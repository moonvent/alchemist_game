extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D


var SPEED = 75.0
const JUMP_VELOCITY = -400.0

var is_attacking = false

enum AttackSide {
	UP,
	LEFT,
	DOWN,
	RIGHT,
}

var collision_attack: Node2D = null

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

	_play_attack_sprite_animation(
		attack_direction	
	)


func _on_animated_sprite_2d_animation_finished():
	# print(1)
	# need to setup argument about animation which finish for stop moving in enemy for example
	var current_animation = sprite.animation

	if is_attacking and current_animation.begins_with('attack_'):
		_stop_attack()


func _on_animated_sprite_2d_frame_changed():
	if sprite and collision_attack:
		var current_frame_number = sprite.frame

		for collision_frame_area_number in range(collision_attack.get_child_count()):
			collision_attack.get_child(collision_frame_area_number).get_child(0).disabled = (collision_frame_area_number != current_frame_number)

func _start_attack(attack_position_point: Vector2):
	is_attacking = true # make one attack for a little period
	_attack(attack_position_point)

func _stop_attack():
	is_attacking = false
