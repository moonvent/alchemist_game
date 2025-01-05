extends Node2D

class_name AttackBehavior

enum AttackSide {
	UP,
	LEFT,
	DOWN,
	RIGHT,
}

var sprite
var primary_sword_damage_per_collider = 0.25

var collision_attack: Node2D = null

var is_attacking = false


func _init(_sprite) -> void:
	sprite = _sprite


func _ready():
	_setup_attack_collisions()

	sprite.connect(
		"_on_animated_sprite_2d_animation_finished", _on_animated_sprite_2d_animation_finished
	)
	sprite.connect("_on_animated_sprite_2d_frame_changed", _on_animated_sprite_2d_frame_changed)


func _on_attack_collider_body_entered(body):
	if body != self:
		body.make_damage(primary_sword_damage_per_collider)


func _setup_attack_collisions():
	var attack_colliders_list = [
		get_node("../Collisions/Attack/Up"),
		get_node("../Collisions/Attack/Left"),
		get_node("../Collisions/Attack/Down"),
		get_node("../Collisions/Attack/Right"),
	]
	for collider in attack_colliders_list:
		for one_attack_frame in collider.get_children():
			one_attack_frame.connect("body_entered", _on_attack_collider_body_entered)


func _play_attack_sprite_animation(attack_side: AttackSide):
	match attack_side:
		AttackSide.UP:
			collision_attack = get_node("../Collisions/Attack/Up")
			sprite.play("attack_up")
		AttackSide.LEFT:
			collision_attack = get_node("../Collisions/Attack/Left")
			sprite.play("attack_left")
		AttackSide.DOWN:
			collision_attack = get_node("../Collisions/Attack/Down")
			sprite.play("attack_down")
		AttackSide.RIGHT:
			collision_attack = get_node("../Collisions/Attack/Right")
			sprite.play("attack_right")


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


func _on_animated_sprite_2d_frame_changed():
	if sprite and collision_attack:
		var current_frame_number = sprite.frame
		if current_frame_number == 3:
			current_frame_number = 2
		if current_frame_number == 4:
			current_frame_number = -1
		_activate_attack_collider(current_frame_number)


func _stop_attack():
	is_attacking = false


func _on_animated_sprite_2d_animation_finished():
	# need to setup argument about animation which finish for stop moving in enemy for example
	print("fin")
	var current_animation = sprite.animation

	if is_attacking and current_animation.begins_with("attack_"):
		_activate_attack_collider(-1)
		_stop_attack()


func _activate_attack_collider(collider_index: int):
	var is_disable_collider: int = 1

	for collision_frame_area_number in range(collision_attack.get_child_count()):
		if collider_index == -1:
			is_disable_collider = 1
		else:
			is_disable_collider = collision_frame_area_number != collider_index

		collision_attack.get_child(collision_frame_area_number).get_child(0).disabled = (is_disable_collider)
