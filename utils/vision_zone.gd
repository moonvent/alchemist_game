extends Node2D

class_name VisionZone

var forward_vector: Vector2
var vision_angle: int
var vision_range: int


func _ready():
	var parent = get_parent()
	vision_angle = parent.vision_angle
	vision_range = parent.vision_range
	forward_vector = parent.forward_vector


func redraw(new_forward_vector: Vector2):
	forward_vector = new_forward_vector
	queue_redraw()


func _draw():
	var angle_start = forward_vector.angle() - deg_to_rad(vision_angle)
	var angle_end = forward_vector.angle() + deg_to_rad(vision_angle)
	var step = (angle_end - angle_start) / 50

	var points = [Vector2.ZERO]
	var angle = 0

	for i in range(51):
		angle = angle_start + step * i
		points.append(Vector2(cos(angle), sin(angle)) * vision_range)

	draw_polygon(points, [Color(1, 0, 0, 0.5)])
