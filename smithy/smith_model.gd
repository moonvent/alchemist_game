extends Node2D

class_name SmithModel

var _selected_part: SmithPart


func switch_select_part(part: SmithPart):
	if _selected_part:
		_selected_part.is_selected = false
	part.is_selected = true
	_selected_part = part
