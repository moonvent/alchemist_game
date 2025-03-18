extends Node

enum WorldEventOperation { Add, Minus, Multiply, Divide }

var global_world_storage: Dictionary = {}


class WorldEvent:
	var name: String
	var value: String
	var event_operation: WorldEventOperation

	var world_state_param: String


class MoveEvent:
	extends WorldEvent
	pass


class QuestEvent:
	extends WorldEvent

	func _init():
		pass


class AttackEvent:
	extends WorldEvent
	var from: String
	var to: String

	func _init(_from: String, _to: String, _value: String, _event_operation: WorldEventOperation):
		self.name = "attack"
		self.event_operation = _event_operation
		self.from = _from
		self.to = _to


class DealDamageEvent:
	extends AttackEvent

	func _init(_from: String, _to: String, _value: String, _event_operation: WorldEventOperation):
		super(_from, _to, _value, _event_operation)
		self.name = "deal damage"


func emit_event(event: WorldEvent):
	QuestWorker.emit_event(event)


func _handle_event():
	pass
