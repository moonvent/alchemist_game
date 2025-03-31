extends "res://character/base_entity.gd"

@onready var sprite = $AnimatedSprite2D

var health_points = 10
var primary_sword_damage_per_collider = 0.25

var collision_attack: Node2D = null

var is_dead = false

enum AttackSide {
	UP,
	LEFT,
	DOWN,
	RIGHT,
}

var is_attacking = false


func _ready():
	_setup_attack_collisions()


func die():
	is_dead = true
	print(name, " die")
	# WorldHandler.update_world_state(
	# 	DialogParamWorker("DieEvent", name, DialogParamWorker.ParamType.WorldState)
	# )
	# set_collision_layer(2)
	# set_collision_mask(2)


func make_damage(damage_points: float, who: BaseCharacter):
	health_points -= damage_points

	print(
		who.name,
		" deal damage to: ",
		name,
		", current hp: ",
		health_points,
		", damage ",
		damage_points
	)
	WorldListenerCore.emit_event(
		WorldListenerCore.DealDamageEvent.new(who.name, name, str(damage_points))
	)

	if health_points == 0:
		die()


func on_attack_collider_body_entered(body, damage: float):
	if body is BaseCharacter:
		body.make_damage(damage, self)


func _setup_attack_collisions():
	var attack_colliders_list = [
		$Collisions/Attack/Up,
		$Collisions/Attack/Left,
		$Collisions/Attack/Down,
		$Collisions/Attack/Right,
	]
	for collider in attack_colliders_list:
		for one_attack_frame in collider.get_children():
			one_attack_frame.connect(
				"body_entered", on_attack_collider_body_entered, primary_sword_damage_per_collider
			)
			one_attack_frame.collision_layer = collision_layer
			one_attack_frame.collision_mask = collision_mask


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
