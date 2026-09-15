class_name State_Stun extends State

@export var player_knockback_speed: float = 200.0
@export var player_invulnerable_duration: float = 1
@export var player_decelerate_speed : float = 3.0


var hurt_box: HurtBox
var direction: Vector2

var next_state: State = null
@onready var idle_state: State = $"../Idle"


func init() -> void:
	player.player_damaged.connect(_player_damaged)


func Enter() -> void:
	#next_state = null
	player.UpdateAnimation("stun")
	player.animation_player.animation_finished.connect( _animation_finished )

	# Damage direction
	if hurt_box:
		direction = hurt_box.global_position.direction_to( player.global_position )
	else:
		direction = Vector2.ZERO

	# Apply knockback
	player.velocity = direction * player_knockback_speed
	player.SetDirection()
	# Invulnerability
	player.make_invulnerable(player_invulnerable_duration)
	# Visual effects on player
	player.effect_animation_player.play("player_damaged")

func Exit() -> void:
	next_state = null
	if player.animation_player.animation_finished.is_connected(_animation_finished):
		player.animation_player.animation_finished.disconnect(_animation_finished)

func Process(_delta: float) -> State:
	player.velocity -= player.velocity * player_decelerate_speed * _delta
	return next_state

func Physics(_delta: float) -> State:
	# The player is decelerated to zero, with a speed of 5.0 a 15.0
	player.velocity = player.velocity.lerp(Vector2.ZERO, player_decelerate_speed * _delta)

	# Drop the velocity if it is very low to avoid small fluctuations
	if player.velocity.length_squared() < 100.0: # ~10 px/s
		player.velocity = Vector2.ZERO

	player.move_and_slide()
	return null

func HandleInput(_event: InputEvent) -> State:
	return null

func _player_damaged(hurt_box: HurtBox) -> void:
	self.hurt_box = hurt_box
	state_machine.ChangeState(self)
	pass

func _animation_finished(_animation_name: StringName) -> void:
	next_state = idle_state
