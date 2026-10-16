extends CatState
class_name CatStateIdle

@export var anim_name : String = "idle"
# Distance to start following
@export var detection_radius : float = 120.0

var _player : Node2D = null

func Enter() -> void:
	cat.velocity = Vector2.ZERO
	cat.UpdateAnimation(anim_name)
	_player = PlayerManager.player

func Physics(_delta: float) -> CatState:
	if _player == null:
		_player = PlayerManager.player
		return null

	# Verify if the player is within detection radius to transition to follow state
	var dist : float = (cat.global_position - _player.global_position).length()
	if dist <= detection_radius:
		# Initiate the follow state
		for s in state_machine.states:
			if s is CatStateFollow:
				return s

	return null
