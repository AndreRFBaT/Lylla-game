extends Node
class_name CatStateMachine

var states : Array[CatState] = []
var prev_state : CatState
var current_state : CatState


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func _process(delta: float) -> void:
	if current_state:
		ChangeState(current_state.Process(delta))


func _physics_process(delta: float) -> void:
	if current_state:
		ChangeState(current_state.Physics(delta))


func initialize(_cat: CatNPC) -> void:
	states = []
	for c in get_children():
		if c is CatState:
			states.append(c)

	for s in states:
		s.cat = _cat
		s.state_machine = self
		s.init()

	if states.size() > 0:
		# Set the initial target state to the first state in the list
		var initial_target_state = states[0]

		# Verify if the current scene is "lylla_house" and set the initial target state to "Wander" if it exists
		var current_scene_file = get_tree().current_scene.scene_file_path
		if "lylla_house" in current_scene_file:
			#TODO = "Create a Wander state when they are in the Lylla's house"
			# Search for the "Wander" state in the states array or idle
			for s in states:
				# Wander is used for now
				if s.name == "Wander" or "Wander" in s.name:
					initial_target_state = s
					break

		ChangeState(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT


func ChangeState(new_state: CatState) -> void:
	if new_state == null or new_state == current_state:
		return

	if current_state:
		current_state.Exit()

	prev_state = current_state
	current_state = new_state
	current_state.Enter()
