extends Inventory

class_name BagInventory


func _init() -> void:
	cells = []
	var one_row = []

	for i in range(0, 5):
		one_row.empty()

		for j in range(0, 5):
			one_row.append(Cell.new(str(i) + str(j)))

		cells.append(one_row)

	inventory_type = Inventory.InventoryType.Bag
