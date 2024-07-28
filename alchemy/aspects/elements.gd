extends Node


enum Element{
	Fire,
	Water,
	Earth,
	Air,

	Steam,
	Light,
	Plant,
	Wind,
	Stone,
	Lava,

	Tree,
	Grass,
	Life,
	Ore,
}


const ElementLevelMap = {
	Element.Fire: 1,
	Element.Water: 1,
	Element.Air: 1,
	Element.Earth: 1,

	Element.Steam: 2,
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


class AlchemyElementData:
	var element: Element
	var name: String
	var picture: String
	var level: int

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


var InitializedElements = {
	Element.Fire: AlchemyElementData.new(Element.Fire),
	Element.Water: AlchemyElementData.new(Element.Water),
	Element.Air: AlchemyElementData.new(Element.Air),
	Element.Earth: AlchemyElementData.new(Element.Earth),

	Element.Steam: AlchemyElementData.new(Element.Steam),
}


