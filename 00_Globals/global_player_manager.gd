extends Node

const PLAYER = preload("uid://c25w8dn51pv85")

var player : Player
var player_spawned : bool = false
# keep player spawn position
var spawn_position : Vector2 = Vector2.ZERO

func _ready() -> void:
	add_player_instance()
	await get_tree().create_timer(0.5).timeout
	player_spawned = true

func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child(player)

func set_player_spawn_postion(_player_new_position : Vector2) -> void:
	spawn_position = _player_new_position
	# if player.is_inside_tree():, update_player_position immediately
	if player and player.is_inside_tree():
		player.global_position = spawn_position

func set_as_parent(_p : Node2D) -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)
	_p.add_child(player)

	# Apply spawn position AFTER the player enters the scene tree
	player.global_position = spawn_position

func unparent_player(_p : Node2D) -> void:
	_p.remove_child(player)
