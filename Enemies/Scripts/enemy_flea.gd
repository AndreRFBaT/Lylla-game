@tool
class_name EnemyFlea extends Enemy

# Change scale value as needed
#@export var enemy_scale : Vector2 = Vector2(0.5, 0.5) 
@export var enemy_scale : Vector2 = Vector2(0.5, 0.5):
	set(value):
		enemy_scale = value
		if is_inside_tree() and sprite:
			sprite.scale = enemy_scale

func _ready() -> void:
	# Change the scale of the sprite to the desired value
	if sprite:
		sprite.scale = enemy_scale
	# if inside editor, stop to not execute IA logic
	if Engine.is_editor_hint():
		return

	state_machine.initialize(self)
	player = PlayerManager.player
	hit_box.Damage.connect(_take_damage)

	sprite.scale = enemy_scale


func _physics_process(_delta: float) -> void:
	move_and_slide()

func SetDirection(_new_direction : Vector2) -> bool:
	direction = _new_direction
	if direction == Vector2.ZERO:
		return false

	# Wrapi grants that index stay between 0 and DIR_4.size() - 1 (0 to 3)
	var direction_id : int = wrapi(
		int(round((direction + cardinal_directions * 0.1).angle() / TAU * DIR_4.size())),
		0,
		DIR_4.size()
	)
	var new_direction = DIR_4[direction_id]

	if new_direction == cardinal_directions:
		return false

	cardinal_directions = new_direction

	# Keep the configuration scale on enemy_scale and do H flip
	var flip_factor : float = -1.0 if cardinal_directions == Vector2.LEFT else 1.0
	sprite.scale.x = enemy_scale.x * flip_factor
	sprite.scale.y = enemy_scale.y
	return true

func UpdateAnimation(state: String) -> void:
	# stun or destroy animation
	if animation_player.has_animation(state):
		animation_player.play(state)
		return
	# If dont exist, play animation with sufixe (_down, _side, _up)
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


func _take_damage( hurt_box : HurtBox ) -> void:
	#if invulnerable or damage <= 0:
	if hurt_box.damage <= 0:
		return
	if invulnerable:
		return
	# Enemy HP
	hp -= hurt_box.damage
	print("Damage from enemy: ", hurt_box.damage, " | HP mount: ", hp)
	# Enemy is alive?
	if hp > 0:
		enemy_damaged.emit( hurt_box )
	else:
		#emit_signal("enemy_destroyed")
		invulnerable = false
		enemy_destroyed.emit( hurt_box )
