extends TabContainer


var _element_grid_container: GridContainer


func _fill_element_tab():
	for element in AlchemyElements.Element:

		var element_data = AlchemyElements.InitializedElements.get(AlchemyElements.Element[element])

		if element_data:
			var temp_label = Label.new()
			temp_label.text = element_data.name
			_element_grid_container.add_child(temp_label)


func _ready():
	_element_grid_container = get_child(0).get_node("GridContainer")
	_fill_element_tab()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
