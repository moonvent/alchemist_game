extends TabContainer

class_name AlchemyTableElementList

var _element_grid_container: GridContainer
var _table_element: AlchemyTable
var _alchemy_table_grid_element = preload(
	"res://scenes/alchemy/table/alchemy_table_grid_element.tscn"
)


func _fill_element_tab():
	for element_name in AspectsWorker.aspects:
		_element_grid_container.add_child(
			_alchemy_table_grid_element.instantiate().set_element(
				AspectsWorker.aspects[element_name]
			)
		)


func _ready():
	_element_grid_container = get_child(0).get_node("GridContainer")
	_table_element = get_parent()
	_fill_element_tab()

# func _draw():
# 	draw_rect(get_rect(), Color.RED)
