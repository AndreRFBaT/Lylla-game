extends Node
class_name CatState

var cat : CatNPC
var state_machine : CatStateMachine


func init() -> void:
	pass


func Enter() -> void:
	pass


func Exit() -> void:
	pass


func Process(_delta: float) -> CatState:
	return null


func Physics(_delta: float) -> CatState:
	return null
