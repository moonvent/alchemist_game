extends TabContainer

class_name AlchemyTableElementList

var _element_grid_container: GridContainer
var _table_element: AlchemyTable


func _fill_element_tab():
	for element_name in AspectsWorker.aspects:
		_element_grid_container.add_child(
			AlchemyTableGridElement.new(AspectsWorker.aspects[element_name])
		)


func _ready():
	_element_grid_container = get_child(0).get_node("GridContainer")
	_table_element = get_parent()
	_fill_element_tab()

# func _draw():
# 	draw_rect(get_rect(), Color.RED)
