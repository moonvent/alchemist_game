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


const ElementData = {
	Element.Fire: "Fire",
	Element.Water: "Water",
	Element.Earth: "Earth",
	Element.Air: "Air",

	Element.Steam: "Steam",
}

const ELEMENT_CREATION_MAP = {
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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
