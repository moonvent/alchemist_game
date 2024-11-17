extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0


func _play_sprite_animation(direction: Vector2):
	if direction.y and direction.x:
		sprite.play("move_down" if direction.y > 0 else "move_up")
	elif direction.y:
		sprite.play("move_down" if direction.y > 0 else "move_up")
	elif direction.x:
		sprite.play("move_right" if direction.x > 0 else "move_left")
	else:
		sprite.stop()
