extends Panel


func _ready() -> void:
	queue_redraw()
	draw_line_for_last_child()


# func _physics_process(delta):
# 	queue_redraw()


func _draw():
	draw_line_for_last_child()


func _draw_line_between_aspects(first_element, second_element, parent: bool = true):
	draw_line(
		first_element.position + AlchemyTableElement.CUSTOM_MINIMUM_SIZE / 2,
		second_element.position + AlchemyTableElement.CUSTOM_MINIMUM_SIZE / 2,
		Color.RED if parent else Color.YELLOW,
		2.0
	)


func draw_line_for_last_child():
	var current_children = get_children()

	var first_element: Control
	var second_element: Control

	var first_element_name: String

	for first_aspect_index in range(0, current_children.size()):
		first_element = current_children[first_aspect_index]
		first_element_name = first_element.element.name.to_lower()

		for second_aspect_index in range(0, current_children.size() - 1):
			if first_aspect_index == second_aspect_index:
				continue

			second_element = current_children[second_aspect_index]

			if (
				first_element_name in second_element.element.child_elements
				or first_element_name in second_element.element.parent_elements
			):
				_draw_line_between_aspects(first_element, second_element, false)
			# if first_element_name in second_element.element.parent_elements:
			# 	_draw_line_between_aspects(first_element, second_element, false)
