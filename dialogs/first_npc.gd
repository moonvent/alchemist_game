var dialogues = {
	"npc_greeting":
	{
		"text": "npc_greeting",
		"options":
		[
			{"text": "option_who_are_you", "next": "npc_identity"},
			{"text": "option_goodbye", "next": "end"}
		]
	},
	"npc_identity":
	{"text": "npc_identity", "options": [{"text": "option_thank_you", "next": "end"}]},
	"test":
	{
		"text": "test",
		"options": [{"text": "test1", "next": "end"}, {"text": "test2", "next": "end"}]
	}
}
