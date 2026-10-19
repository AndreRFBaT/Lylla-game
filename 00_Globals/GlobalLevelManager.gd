extends Node

signal level_load_started
signal level_loaded
signal tilemap_bounds_changed( bounds : Array[ Vector2 ])
signal TileMapBoundsChange( bounds : Array[ Vector2 ])


var current_tilemap_bounds : Array [ Vector2 ]
var target_transition : String
var position_offset : Vector2

var is_cat_following : bool = false
# PackedScene for the cat to be instantiated in the new level
var cat_packed_scene : PackedScene = null

func _ready() -> void:
	await  get_tree().process_frame
	level_loaded.emit()

func ChangeTilemapBounds ( bounds : Array[ Vector2 ] ) -> void:
	current_tilemap_bounds = bounds
	TileMapBoundsChange.emit( bounds )

func load_new_level(
		level_path : String,
		_target_transition : String,
		_position_offset : Vector2
) -> void:

	get_tree().paused = true
	target_transition = _target_transition
	position_offset = _position_offset

	### Level transition in this point ###
	# Add BLACK screen to level transition animation
	await SceneTransitionGui.fade_out()
	# Emit signal to start level load
	level_load_started.emit()
	# Change level scene
	get_tree().change_scene_to_file( level_path )
	# Wait two frames que grant new level and _ready build on tree
	await get_tree().process_frame
	await get_tree().process_frame

	if is_cat_following and cat_packed_scene != null:
		var new_cat = cat_packed_scene.instantiate()
		get_tree().current_scene.add_child(new_cat)

		if PlayerManager.player:
			new_cat.global_position = PlayerManager.player.global_position + Vector2(0, 20)

		is_cat_following = false
		cat_packed_scene = null

	# Emit signal for transition while the level is loaded and BLACK screen
	level_loaded.emit()
	# fade in animation for level transition
	await SceneTransitionGui.fade_in()
	# Set false
	get_tree().paused = false
	pass
