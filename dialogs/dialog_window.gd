extends Control

class_name DialogWindow


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TranslationServer.set_locale("ru")
	#$ReplicaOptions/ReplicaOption1.set_text(tr("test1"))


func start_new_dialog(npc_name: String, replica_number: int):
	self.visible = true
	$DialogElements/ReplicaOwnerName.text = npc_name
	$DialogElements/ReplicaText.text = tr(npc_name + "__1")
	#$DialogElements/ReplicaOptions/ReplicaOption1.text = tr(npc_name + "__1")
	# print(tr(dialog_npc.name + "__1"))


func deactivate_dialog():
	self.visible = false
