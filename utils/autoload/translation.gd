extends Node

var current_language = "en"


func _ready():
	set_new_locale(current_language)


func set_new_locale(locale: String):
	TranslationServer.set_locale(locale)
