extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D


const SPEED = 75.0
const JUMP_VELOCITY = -400.0

var is_attacking = false

enum AttackSide {
	TOP,
	LEFT,
	BOTTOM,
	RIGHT,
}


func _play_run_sprite_animation(direction: Vector2):
	if direction.y and direction.x:
		sprite.play("move_down" if direction.y > 0 else "move_up")
	elif direction.y:
		sprite.play("move_down" if direction.y > 0 else "move_up")
	elif direction.x:
		sprite.play("move_right" if direction.x > 0 else "move_left")


func _play_attack_sprite_animation(attack_side: AttackSide):
	match attack_side:
		AttackSide.TOP:
			sprite.play("attack_up")
		AttackSide.LEFT:
			sprite.play("attack_left")
		AttackSide.BOTTOM:
			sprite.play("attack_down")
		AttackSide.RIGHT:
			sprite.play("attack_right")


func _attack():

	var diff = get_global_mouse_position() - global_position

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


func _on_animated_sprite_2d_animation_finished():
	print(1)
	# need to setup argument about animation which finish
