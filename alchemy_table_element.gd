# ColorRect.gd
extends ColorRect


class_name AlchemyTableElement


@export var element: AlchemyElements.Element
var element_data: AlchemyElements.AlchemyElementData


var dragging = false
var has_entered = false

var alchemy_table_element_list: AlchemyTableElementList


func custom_init(_element):
	element = _element


func _ready():
	element_data = AlchemyElements.InitializedElements[element]
	$Label.text = element_data.name


func start_dragging():
	dragging = true
	$Area2D.connect("area_entered", _on_area_2d_area_entered)


func stop_dragging():
	dragging = false
	$Area2D.disconnect("area_entered", _on_area_2d_area_entered)
	
	if alchemy_table_element_list and get_rect().intersects(alchemy_table_element_list.get_rect()):
		queue_free()


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:

			if event.pressed:

				if get_rect().has_point(event.position):
					start_dragging()

			else:
				stop_dragging()

	elif event is InputEventMouseMotion:

		if dragging:
			position += event.relative

func _on_area_2d_area_entered(area):
	var alchemy_table_element = area.get_parent()
	var entered_element_name = alchemy_table_element.element
	var elements_to_merge = [entered_element_name, element]
	elements_to_merge.sort()
	var new_element = AlchemyElements.CreationMap.get(elements_to_merge)

	if new_element:
		var self_copy = duplicate()
		self_copy.element = new_element
		get_parent().add_child(self_copy)
		alchemy_table_element.queue_free()
		queue_free()
		

