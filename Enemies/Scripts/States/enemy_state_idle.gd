class_name EnemyStateIdle extends EnemyState

## Store a reference to the enemy that this state belongs to
@export var anim_name : String = "idle"

@export_category("AI")
@export var state_duration_min : float = 0.5
@export var state_duration_max : float = 1.5
@export var after_idle_state : EnemyState

@export_category("Detection")
@export var chase_state : EnemyState
@export var vision_distance : float = 150.0
@export_range(-1.0, 1.0) var vision_angle : float = 0.2

var _timer : float = 0.0


func _init() -> void:
	pass


func Enter() -> void:
	enemy.velocity = Vector2.ZERO
	_timer = randf_range( state_duration_min, state_duration_max )
	enemy.UpdateAnimation( anim_name )


func Exit() -> void:
	pass


func Process(_delta : float) -> EnemyState:
	_timer -= _delta
	if _timer <= 0:
		return after_idle_state
	return null


func Physics(_delta: float) -> EnemyState:
	if enemy.player == null:
		return null

	# Distance and direction to the player
	var vec_to_player : Vector2 = enemy.player.global_position - enemy.global_position
	var dist_to_player : float = vec_to_player.length()

	# Check if the player is within the enemy's vision distance and angle
	if dist_to_player <= vision_distance:
		var facing_dir : Vector2 = enemy.cardinal_directions.normalized()
		var dir_to_player : Vector2 = vec_to_player.normalized()

		# Calculate the dot product to determine if the player is within the vision angle
		var dot : float = facing_dir.dot(dir_to_player)

		if dot >= vision_angle:
			return chase_state

	return null
