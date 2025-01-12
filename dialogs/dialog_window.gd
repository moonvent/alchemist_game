extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TranslationServer.set_locale("ru")
	$ReplicaOptions/ReplicaOption1.set_text(tr("test1"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
