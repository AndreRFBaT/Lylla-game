class_name EnemyStateChase extends EnemyState

# Name for type of animation
@export var anim_name : String = "walk"
@export var move_speed : float = 60.0

@export_category("AI Targets")
@export var lose_distance : float = 220.0
@export var attack_distance : float = 24.0

@export_category("State Transitions")
@export var next_state : EnemyState
@export var attack_state : EnemyState

var _player : Player


func Enter() -> void:
	_player = enemy.player
	# Play the initial animation
	enemy.UpdateAnimation( anim_name )


func Exit() -> void:
	enemy.velocity = Vector2.ZERO


func Process(_delta : float) -> EnemyState:
	return null


func Physics(_delta : float) -> EnemyState:
	if _player == null:
		return next_state

	var vec_to_player : Vector2 = _player.global_position - enemy.global_position
	var dist_to_player : float = vec_to_player.length()

	# Lose distance
	if dist_to_player > lose_distance:
		return next_state

	# Attack distance
	if attack_state != null and dist_to_player <= attack_distance:
		return attack_state
	# Move direction
	var move_direction : Vector2 = vec_to_player.normalized()
	# Set direction and update animation
	var direction_changed : bool = enemy.SetDirection( move_direction )
	# Update animation if direction changed
	if direction_changed:
		enemy.UpdateAnimation( anim_name )

	enemy.velocity = move_direction * move_speed

	return null
