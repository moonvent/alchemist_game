extends "res://character/base_character.gd"

class_name NPC

var vision_range: int = 100
var vision_angle: float = 60
var attack_range: int = 15

var player: Player

var _target: CharacterBody2D

# see only in up
var forward_vector: Vector2 = Vector2.UP

var vision_zone_node: Node2D

var target_follow_behavior: TargetFollowBehavior


func _ready():
	player = get_node("%Player")
	SPEED = 35  # only for test
	super._ready()
	$DialogAreaTrigger.connect("body_entered", activate_dialog_hover)
	$DialogAreaTrigger.connect("body_exited", deactivate_dialog_hover)


func _physics_process(delta):
	pass


func activate_dialog_hover(body):
	if body == player:
		$DialogAvailable.visible = true
		player.dialog_npc = self
		return true


func deactivate_dialog_hover(body):
	if body == player:
		$DialogAvailable.visible = false
		body.deactivate_dialog()
		player.dialog_npc = null
		return true
