extends "res://character/attack_character.gd"

class_name BaseCharacter

var SPEED = 75.0
const JUMP_VELOCITY = -400.0


func _ready():
	super._ready()


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
