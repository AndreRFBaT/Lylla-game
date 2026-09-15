extends Node

signal level_load_started
signal level_loaded
signal tilemap_bounds_changed( bounds : Array[ Vector2 ])
signal TileMapBoundsChange( bounds : Array[ Vector2 ])


var current_tilemap_bounds : Array [ Vector2 ] 
var target_transition : String
var position_offset : Vector2

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
	# Emit signal for transition while the level is loaded and BLACK screen
	level_loaded.emit()
	# fade in animation for level transition
	await SceneTransitionGui.fade_in()
	# Set false
	get_tree().paused = false
	pass
