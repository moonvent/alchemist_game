class_name Cell

var _cell_id: String
var _contain_item_id: int


func _init(cell_id: String) -> void:
	_cell_id = cell_id


func is_busy() -> bool:
	return bool(contain_item_id)


func add_item_part(item_part_id: int):
	_contain_item_id = item_part_id
