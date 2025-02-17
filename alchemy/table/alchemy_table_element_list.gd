extends TabContainer


class_name AlchemyTableElementList


var _element_grid_container: GridContainer
var _table_element: AlchemyTable


func _fill_element_tab():
	for element in AlchemyElements.Element:

		var element_data = AlchemyElements.InitializedElements.get(AlchemyElements.Element[element])

		if element_data:
			var temp_label = AlchemyTableGridElement.new()
			temp_label.curstom_init(element_data, _table_element)
			_element_grid_container.add_child(temp_label)


func _ready():
	_element_grid_container = get_child(0).get_node("GridContainer")
	_table_element = get_parent()
	_fill_element_tab()
