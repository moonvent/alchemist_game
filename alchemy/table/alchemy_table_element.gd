extends ColorRect

class_name AlchemyTableElement

@export var element_name: String
var element: AspectElement

var dragging = false
var has_entered = false

var alchemy_table_element_list: AlchemyTableElementList


func _ready():
	# if we setup it from debug window
	if not element:
		element = AspectsWorker.aspects[element_name]
	$VBoxContainer/Label.text = element.name
	# var collision_shape = $Area2D.get_node("CollisionShape2D")
	#collision_shape.shape.radius += 5 + element_data.radius
	# var material = CanvasItemMaterial.new()
	#material.self_modulate = Color(1, 0, 0, 0.5)
	#collision_shape.material = material


func start_dragging():
	dragging = true
	$VBoxContainer/Area2D.connect("area_entered", _on_area_2d_area_entered)


func stop_dragging():
	dragging = false
	$VBoxContainer/Area2D.disconnect("area_entered", _on_area_2d_area_entered)

	if alchemy_table_element_list and get_rect().intersects(alchemy_table_element_list.get_rect()):
		queue_free()


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				start_dragging()

			else:
				stop_dragging()

	elif event is InputEventMouseMotion:
		if dragging:
			position += event.relative


func _on_area_2d_area_entered(area):
	var alchemy_table_element = area.get_parent().get_parent()
	var entered_element_name = alchemy_table_element.element
	var elements_to_merge = [entered_element_name.name, element.name]
	elements_to_merge.sort()

	var new_element = AspectsWorker.creation_map.get(elements_to_merge)

	if new_element:
		var self_copy = duplicate()
		self_copy.element = new_element
		get_parent().add_child(self_copy)
		alchemy_table_element.queue_free()
		queue_free()
