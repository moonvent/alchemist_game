extends Panel

class_name Research

var _begin_point: Vector2
var _end_point: Vector2

var _hole_areas: Array[Vector2]
var _timer_areas: Array[Vector2]

var _distance_to_connect: int = 100


func _ready() -> void:
	queue_redraw()


func _draw():
	_draw_lines_for_aspects()


func _draw_line_between_aspects(first_element, second_element, parent: bool = true):
	draw_line(
		first_element.get_node_center_point(),
		second_element.get_node_center_point(),
		Color.RED if parent else Color.YELLOW,
		2.0
	)


func _draw_lines_for_aspects():
	var current_children = get_children()

	var first_element: AlchemyTableElement
	var second_element: AlchemyTableElement

	var first_element_name: String

	for first_aspect_index in range(0, current_children.size()):
		first_element = current_children[first_aspect_index]
		first_element_name = first_element.element.name.to_lower()

		for second_aspect_index in range(0, current_children.size() - 1):
			if first_aspect_index == second_aspect_index:
				continue

			second_element = current_children[second_aspect_index]

			if (
				(
					first_element.get_node_center_point().distance_to(
						second_element.get_node_center_point()
					)
					<= _distance_to_connect
				)
				and (
					first_element_name in second_element.element.child_elements
					or first_element_name in second_element.element.parent_elements
				)
			):
				_draw_line_between_aspects(first_element, second_element, false)
