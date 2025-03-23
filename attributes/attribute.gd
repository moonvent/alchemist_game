class_name Attribute

enum AttributeName { MoveSpeed, AttackSpeed }

var _name: AttributeName
var _value: Variant


func get_value() -> Variant:
	return _value


func set_value(value: Variant):
	_value = value
