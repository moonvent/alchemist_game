extends Button


class_name AlchemyTableGridElement


var element: AlchemyElements.AlchemyElementData
var _table_element: AlchemyTable
var _alchemy_table_element_prefab = preload("res://alchemy_table_element.tscn")
var _alchemy_table_element_list: AlchemyTableElementList


func curstom_init(_element: AlchemyElements.AlchemyElementData, _table: AlchemyTable):
	element = _element
	_table_element = _table
	connect("button_down", _on_pressed)


func _ready():
	text = element.name


func _on_pressed():
	var alchemy_table_element = _alchemy_table_element_prefab.instantiate()
	alchemy_table_element.custom_init(element.element)
	alchemy_table_element.position = get_global_mouse_position()
	alchemy_table_element.start_dragging()
	alchemy_table_element.alchemy_table_element_list = _table_element.get_node('AlchemyTableElementList')
	_table_element.add_child(alchemy_table_element)
