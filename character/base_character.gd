extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0

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
