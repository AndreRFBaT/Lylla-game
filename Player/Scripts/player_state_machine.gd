class_name PlayerStateMachine extends Node

var states : Array[ State ]
var prev_state : State
var current_state : State

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta: float) -> void:
	ChangeState(current_state.Process(delta))

func _physics_process(delta: float) -> void:
	ChangeState(current_state.Physics(delta))

func _unhandled_input(event: InputEvent) -> void:
	ChangeState(current_state.HandleInput(event))

func Initialize(_player : Player) -> void:
	states = []

	# Player states for each state
	for c in get_children():
		if c is State:
			states.append(c)
			c.player = _player
			c.state_machine = self

	if states.size() == 0:
		return
	#states[0].player = _player
	#states[0].state_machine = self
	for state in states:
		state.init()

	ChangeState(states[0])
	process_mode = Node.PROCESS_MODE_INHERIT

func ChangeState(new_state : State) -> void:
	if new_state == null || new_state == current_state:
		return
	if current_state:
		current_state.Exit()

	prev_state = current_state
	current_state = new_state
	print("[LOG FOR STATE MACHINE] Changing state for: ", current_state.name)
	current_state.Enter()

func _input(event: InputEvent) -> void:
	ChangeState(current_state.HandleInput(event))
