extends Panel

class_name Research

var _begin_point: Vector2
var _end_point: Vector2

var _start_element: AlchemyTableElement
var _end_element: AlchemyTableElement

var _alchemy_table_element_prefab = preload("res://scenes/alchemy/table/alchemy_table_element.tscn")

var _hole_areas: Array[Vector2]
var _timer_areas: Array[Vector2]

var _distance_to_connect: int = 100

var research_mode: bool = false

var last_dragged_element: AlchemyTableElement

var _elements_to_draw_line: Array[Array] = []


func _ready() -> void:
	queue_redraw()
	_start_element = $StartElement
	_end_element = $EndElement
	research_mode = true
	get_parent().find_child("ResearchModeButton").button_pressed = research_mode


func _draw():
	_draw_line_between_aspects()


func _draw_line_between_aspects():
	for one_line_elements in _elements_to_draw_line:
		draw_line(
			one_line_elements[0].get_node_center_point(),
			one_line_elements[1].get_node_center_point(),
			Color.YELLOW,
			2.0
		)


func change_connected_elements(
	first_element: AlchemyTableElement, second_element: AlchemyTableElement, remove: bool = false
):
	var temp_elements_connection = [first_element, second_element]
	temp_elements_connection.sort_custom(
		func(f_elem, s_elem): return f_elem.get_instance_id() < s_elem.get_instance_id()
	)

	if remove:
		_elements_to_draw_line.erase(temp_elements_connection)
	else:
		# if temp_elements_connection not in _elements_to_draw_line:
		_elements_to_draw_line.append(temp_elements_connection)

	queue_redraw()
	_is_complete_research()


func _is_complete_research():
	var graph: Dictionary[AlchemyTableElement, Array] = {}
	for elements in _elements_to_draw_line:
		if graph.has(elements[0]):
			graph[elements[0]].append(elements[1])
		else:
			graph[elements[0]] = [elements[1]]

		if graph.has(elements[1]):
			graph[elements[1]].append(elements[0])
		else:
			graph[elements[1]] = [elements[0]]

	if _search_end_point(graph, _start_element, {}):
		print("grats")


func _search_end_point(
	graph: Dictionary[AlchemyTableElement, Array],
	parent_point: AlchemyTableElement,
	visited: Dictionary[AlchemyTableElement, Array]
) -> bool:
	for child in graph.get(parent_point, []):
		if child in visited.get(parent_point, []) or parent_point in visited.get(child, []):
			continue
		elif child == _end_element:
			return true

		if visited.has(parent_point):
			visited[parent_point].append(child)
		else:
			visited[parent_point] = [child]

		return _search_end_point(graph, child, visited)
	return false
