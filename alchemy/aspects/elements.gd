extends Node


# english alphabet
# A B C D 
# E F G H 
# I J K L 
# M N O P 
# Q R S T 
# U V W X Y 
# Z


enum Element{
	Air,
	Earth,
	Fire,
	Water,

	Lava,
	Light,
	Plant,
	Steam,
	Stone,
	Wind,

	Grass,
	Life,
	Ore,
	Tree,
}


const ElementLevelMap = {
	Element.Fire: 1,
	Element.Water: 1,
	Element.Air: 1,
	Element.Earth: 1,

	Element.Steam: 2,
	Element.Light: 2,
	Element.Plant: 2,
	Element.Wind: 2,
	Element.Stone: 2,
	Element.Lava: 2,

	Element.Tree: 3,
	Element.Grass: 3,
	Element.Life: 3,
	Element.Ore: 3,
}


const CreationMap = {
	# actually, keys need to be in alphabet order
	[Element.Fire, Element.Water]: Element.Steam,
	[Element.Air, Element.Fire]: Element.Light,
	[Element.Earth, Element.Water]: Element.Plant,
	[Element.Air, Element.Air]: Element.Wind,
	[Element.Earth, Element.Fire]: Element.Stone,
	[Element.Fire, Element.Stone]: Element.Lava,

	[Element.Plant, Element.Plant]: Element.Tree,
	[Element.Earth, Element.Plant]: Element.Grass,
	[Element.Plant, Element.Water]: Element.Life,
	[Element.Earth, Element.Stone]: Element.Ore,
}


const RadiusMap = {
	Element.Air: 5,
	Element.Earth: 5,
	Element.Fire: 5,
	Element.Water: 5,

	Element.Steam: 4,
	Element.Light: 4,
	Element.Plant: 4,
	Element.Wind: 4,
	Element.Stone: 4,
	Element.Lava: 4,

	Element.Tree: 3,
	Element.Grass: 3,
	Element.Life: 3,
	Element.Ore: 3,

}


class AlchemyElementData:
	var element: Element
	var name: String
	var picture: String
	var level: int
	var radius: int

	func _init(_element: Element):
		element = _element
		_set_element_name()
		_setup_element_params()

	func _set_element_name():
		for _name in Element:
			if Element[_name] == element:
				name = _name

	func _setup_element_params():
		level = ElementLevelMap.get(element)
		radius = RadiusMap.get(element)


func _generate_initialized_elements():
	var initialized_elements = {}
	var element_number = 0

	for element in Element:
		element_number = Element[element]
		initialized_elements[element_number] = AlchemyElementData.new(element_number)

	return initialized_elements


var InitializedElements = _generate_initialized_elements()
