extends ColorRect

class_name AlchemyTableElement

@export var element_name: String
var element: AspectElement

var is_dragging = false
var has_entered = false

var alchemy_table_element_list: AlchemyTableElementList

var _panel_container: Research

var _parent_rect: Rect2

@export var drag_lock: bool = false


func get_node_center_point() -> Vector2:
	return position + size / 2


func _ready():
	# if we setup it from debug window
	if not element:
		element = AspectsWorker.aspects[element_name]
	$Label.text = element.name
	_panel_container = get_parent()

	$ResearchArea.get_node("CollisionShape2D").shape.radius = 50
	# var collision_shape = $ResearchArea.get_node("CollisionShape2D")
	# print(collision_shape.shape.radius)
	# collision_shape.shape.radius += 5 + element_data.radius
	# var material = CanvasItemMaterial.new()
	#material.self_modulate = Color(1, 0, 0, 0.5)
	#collision_shape.material = material


func start_dragging():
	is_dragging = true
	if not _panel_container.research_mode:
		$ElementArea.connect("area_entered", _on_area_2d_area_entered)
	else:
		$ResearchArea.connect("area_entered", element_research_area_entered)
		$ResearchArea.connect("area_exited", element_research_area_exited)


func stop_dragging():
	is_dragging = false
	if not _panel_container.research_mode:
		$ElementArea.disconnect("area_entered", _on_area_2d_area_entered)
	else:
		$ResearchArea.disconnect("area_entered", element_research_area_entered)
		$ResearchArea.disconnect("area_exited", element_research_area_exited)

	if not _parent_rect:
		_parent_rect = Rect2(get_parent().global_position, get_parent().get_rect().size)
	if not _parent_rect.encloses(Rect2(global_position, get_rect().size)):
		queue_free()


func _gui_input(event):
	if drag_lock:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				start_dragging()

			else:
				stop_dragging()

		# _panel_container.queue_redraw()

	elif event is InputEventMouseMotion:
		if is_dragging:
			position += event.relative
			_panel_container.queue_redraw()


func _on_area_2d_area_entered(area):
	var alchemy_table_element = area.get_parent()
	var entered_element_name = alchemy_table_element.element
	var elements_to_merge = [entered_element_name.name, element.name]
	elements_to_merge.sort()

	var new_element = AspectsWorker.creation_map.get(elements_to_merge)

	if new_element:
		var self_copy = duplicate()
		self_copy.element = new_element
		_panel_container.add_child(self_copy)
		alchemy_table_element.queue_free()
		queue_free()
		_panel_container.queue_redraw()


func element_research_area_entered(entered_element):
	if (
		entered_element.get_parent().element.name.to_lower() in element.child_elements
		or entered_element.get_parent().element.name.to_lower() in element.parent_elements
	):
		_panel_container.change_connected_elements(entered_element.get_parent(), self)


func element_research_area_exited(entered_element):
	_panel_container.change_connected_elements(entered_element.get_parent(), self, true)
