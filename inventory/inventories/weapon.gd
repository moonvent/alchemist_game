extends Inventory

class_name WeaponInventory


func _init() -> void:
	cells = [[Cell.new("00"), Cell.new("01")], [Cell.new("10"), Cell.new("11")]]
	inventory_type = Inventory.InventoryType.Weapon
