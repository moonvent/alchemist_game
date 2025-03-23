extends Node

var attribute_storage: Dictionary[String, Dictionary[Attribute.AttributeName, Attribute]] = {}


func _init_new_attribute_storage() -> Dictionary[Attribute.AttributeName, Attribute]:
	return {
		Attribute.AttributeName.MoveSpeed: AttributeMoveSpeed.new(),
		Attribute.AttributeName.AttackSpeed: AttributeAttackSpeed.new()
	}


func get_attribute_value(
	character_name: String, attribute_name: Attribute.AttributeName
) -> Variant:
	return (
		attribute_storage
		. get_or_add(character_name, _init_new_attribute_storage())
		. get(attribute_name)
		. get_value()
	)


func set_attribute_value(
	character_name: String, attribute_name: Attribute.AttributeName, new_value: Variant
) -> Variant:
	return (
		attribute_storage
		. get_or_add(character_name, _init_new_attribute_storage())
		. get(
			attribute_name,
		)
		. set_value(new_value)
	)
