extends "res://character/villager.gd"


func _ready() -> void:
	super._ready()
	load_dialog("dialogs/dialog_lines_jsons/{}.json".format(self.name))
	conditions["first_look"] = true
