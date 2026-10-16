extends CharacterBody2D
class_name CatNPC

@export var cat_scale : Vector2 = Vector2(1.0, 1.0):
	set(value):
		cat_scale = value
		if is_inside_tree() and sprite:
			sprite.scale = cat_scale

var cardinal_directions : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

@onready var sprite: Sprite2D = $Visual/Sprite2D
@onready var animation_player: AnimationPlayer = $Visual/AnimationPlayer
@onready var state_machine: CatStateMachine = $CatStateMachine
@onready var interact_area: Area2D = $InteractiveArea


func _ready() -> void:
	add_to_group("cats")
	if sprite:
		sprite.scale = cat_scale

	state_machine.initialize(self)
	interact_area.body_entered.connect(_on_interact_body)


func _physics_process(_delta: float) -> void:
	# Adjust velocity based on current state
	move_and_slide()


func SetDirection(_new_direction : Vector2) -> bool:
	direction = _new_direction
	if direction == Vector2.ZERO:
		return false

	var direction_id : int = wrapi(
		int(round((direction + cardinal_directions * 0.1).angle() / TAU * DIR_4.size())),
		0,
		DIR_4.size()
	)
	var new_direction = DIR_4[direction_id]

	if new_direction == cardinal_directions:
		return false

	cardinal_directions = new_direction

	# Apply the same rotation/flip via scale that the Flea uses
	var flip_factor : float = -1.0 if cardinal_directions == Vector2.LEFT else 1.0
	sprite.scale.x = cat_scale.x * flip_factor
	sprite.scale.y = cat_scale.y
	return true


func UpdateAnimation(state: String) -> void:
	if animation_player.has_animation(state):
		animation_player.play(state)
		return

	var anim_with_dir : String = state + "_" + AnimDirection()
	if animation_player.has_animation(anim_with_dir):
		animation_player.play(anim_with_dir)


func AnimDirection() -> String:
	if cardinal_directions == Vector2.DOWN:
		return "down"
	elif cardinal_directions == Vector2.UP:
		return "up"
	else:
		return "side"


func _on_interact_body(body: Node2D) -> void:
	if body.is_in_group("player") or body == PlayerManager.player:
		if has_node("CatStateMachine/Follow"):
			state_machine.ChangeState($CatStateMachine/Follow)


func get_following_cats_count() -> int:
	var count := 0
	for cat_node in get_tree().get_nodes_in_group("cats"):
		if cat_node.has_node("CatStateMachine"):
			var sm = cat_node.get_node("CatStateMachine")
			if sm.current_state is CatStateFollow:
				count += 1
	return count
