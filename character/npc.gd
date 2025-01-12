extends "res://character/base_character.gd"

var vision_range: int = 100
var vision_angle: float = 60
var attack_range: int = 5

# see only in up
var forward_vector: Vector2 = Vector2.UP

var vision_zone_node: Node2D

var target_follow_behavior: TargetFollowBehavior


func _ready():
	SPEED = 35  # only for test
	super._ready()


func _physics_process(delta):
	pass
