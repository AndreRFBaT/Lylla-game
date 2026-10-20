extends CatState
class_name CatStateFollow

@export_category("Animações")
@export var anim_walk : String = "walk"
@export var anim_idle : String = "idle"

@export_category("Movimentação do Pet")
@export var follow_speed : float = 130.0
@export var stop_distance : float = 10.0
@export var base_distance_from_player : float = 10.0

@export_category("AI Targets & Transições")
@export var lose_distance : float = 100.0
@export var next_state : CatState 

var _player : Node2D = null
var follow_slot : int = 0
var _is_moving : bool = true

func Enter() -> void:
	_player = PlayerManager.player
	LevelManager.is_cat_following = true

	if cat and cat.scene_file_path != "":
		# Load the cat scene from the path
		LevelManager.cat_packed_scene = load(cat.scene_file_path)

	if cat:
		follow_slot = cat.get_following_cats_count()
		# While entering, if the cat is far away, start walking
		if get_dist_to_target() > stop_distance:
			cat.UpdateAnimation(anim_walk)
		else:
			cat.UpdateAnimation(anim_idle)

func Exit() -> void:
	if cat:
		cat.velocity = Vector2.ZERO

func Physics(_delta: float) -> CatState:
	if _player == null:
		_player = PlayerManager.player
		if _player == null:
			return next_state

	if cat == null:
		return null

	# Distance to target (Verification of Loss)
	var dist_to_player : float = (cat.global_position - _player.global_position).length()

	# If the player is too far, return to the next state
	if dist_to_player > lose_distance:
		return next_state

	# Point of destination of the slot behind the player
	var target_pos : Vector2 = get_target_position()
	var vec_to_target : Vector2 = target_pos - cat.global_position
	var dist_to_target : float = vec_to_target.length()

	# Verify if the stopped condition is met (if the cat is close enough to the slot or if the player stopped moving and the cat is close enough)
	var player_stopped = _player.velocity.length_squared() < 10.0 # Define the minimum velocity to consider the player stopped
	if dist_to_target <= stop_distance or (player_stopped and dist_to_target <= stop_distance * 1.5): # Add more tolerance if the player is stopped
		cat.velocity = Vector2.ZERO
		cat.UpdateAnimation(anim_idle)
		#return null
		if _is_moving:
			_is_moving = false
			# Execute the idle animation
			cat.UpdateAnimation(anim_idle)

		return null

	# Movimentation logic if the player is moving
	if not _is_moving:
		_is_moving = true
		cat.UpdateAnimation(anim_walk) # Execute the walk animation when starting to move

	# Just move if is far enough from the target position
	var move_direction : Vector2 = vec_to_target.normalized()

	cat.SetDirection(move_direction)
	cat.UpdateAnimation(anim_walk)

	# Decelerate the cat when approaching the target position to avoid overshooting
	var current_speed = follow_speed
	if dist_to_target < 60.0:
		current_speed = remap(dist_to_target, stop_distance, 60.0, 20.0, follow_speed)

	cat.velocity = move_direction * current_speed

	return null

# Func to calculate the target position based on the player's position and direction, as well as the follow slot of the cat
func get_target_position() -> Vector2:
	if not _player or not cat:
		return Vector2.ZERO

	var player_dir : Vector2 = Vector2.DOWN
	if "cardinal_directions" in _player and _player.cardinal_directions != Vector2.ZERO:
		player_dir = _player.cardinal_directions
	elif _player.velocity.length_squared() > 0:
		player_dir = _player.velocity.normalized()

	var target_distance := base_distance_from_player + (follow_slot * 25.0)
	var back_offset := -player_dir * target_distance
	var side_offset := player_dir.orthogonal() * ((follow_slot % 2) * 16.0 - 8.0)

	return _player.global_position + back_offset + side_offset

# Func to get the distance from the cat to the target position
func get_dist_to_target() -> float:
	return (get_target_position() - cat.global_position).length()
