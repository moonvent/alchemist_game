extends Button

class_name AlchemyTableGridElement

var _element: AspectElement
var _table_element: AlchemyTable
var _alchemy_table_element_prefab = preload("res://scenes/alchemy/table/alchemy_table_element.tscn")
var _alchemy_table_element_list: AlchemyTableElementList


func _init(element: AspectElement):
	_element = element

	connect("button_down", _on_pressed)


func _ready() -> void:
	text = _element.name


func _on_pressed():
	_table_element = find_parent("AlchemistTable")
	var alchemy_table_element = _alchemy_table_element_prefab.instantiate()
	alchemy_table_element.element = _element
	alchemy_table_element.position = get_global_mouse_position()
	alchemy_table_element.alchemy_table_element_list = _table_element.get_node(
		"AlchemyTableElementList"
	)
	_table_element.add_child(alchemy_table_element)
