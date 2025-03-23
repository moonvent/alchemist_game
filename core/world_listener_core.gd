extends Node

enum WorldEventOperation { Add, Minus, Multiply, Divide, IntAdd, FloatAdd }
enum WorldEventName { Attack, DealDamage, PlayerMove, SpeakWith, AddQuest }

var global_world_storage: Dictionary = {}


class WorldEvent:
	var name: WorldEventName
	var value: String
	var event_operation: WorldEventOperation

	var world_state_param: String


class PlayerMoveEvent:
	extends WorldEvent

	const ONE_METR_IN_PIXELS := 15
	var distance_in_pixels: float

	func _init(_distance_in_pixels: float):
		self.name = WorldEventName.PlayerMove
		self.distance_in_pixels = _distance_in_pixels / ONE_METR_IN_PIXELS


class QuestEvent:
	extends WorldEvent

	func _init():
		pass


class AddQuestEvent:
	extends QuestEvent

	func _init():
		name = WorldEventName.AddQuest


class AttackEvent:
	extends WorldEvent
	var from: String
	var to: String

	func _init(_from: String, _to: String, _value: String):
		self.name = WorldEventName.Attack
		self.from = _from
		self.to = _to
		self.value = _value


class DealDamageEvent:
	extends AttackEvent

	func _init(_from: String, _to: String, _value: String):
		super(_from, _to, _value)
		self.name = WorldEventName.DealDamage


func emit_event(event: WorldEvent):
	QuestWorker.emit_event(event)


func _handle_event():
	pass
