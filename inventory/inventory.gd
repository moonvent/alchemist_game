class_name Inventory

enum InventoryType { Weapon, GrassBag, ArmorBody, ArmorHead, ArmorLegs, Bag }

var cells: Array[Array]  # matrix of cells
var inventory_type: InventoryType


func add_item():
	pass


func remove_item():
	pass
