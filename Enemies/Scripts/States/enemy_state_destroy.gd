class_name EnemyStateDestroy extends EnemyState

@export var anim_name : String = "destroy"
@export var knockback_speed : float = 200.0
@export var decelarate_speed : float = 10.0

@export_category("AI")
#@export var next_idle_state : EnemyState

var _damage_position : Vector2
var _direction : Vector2
#var _animation_finished : bool = false

func init() -> void:
	enemy.enemy_destroyed.connect(_on_enemy_destroyed)

func Enter() -> void:
	enemy.invulnerable = true
	###--------------------------------------------------###
	## I ll left it here for now as a reference
	# Works aswell with inverted player or enemy..
	#_direction = -enemy.global_position.direction_to( enemy.player.global_position )
	#_direction = enemy.player.global_position.direction_to( _damage_position )
	###--------------------------------------------------###

	# Deactivate Enemy HitBox when enter to the state Destroy
	if enemy.has_node("HitBox/CollisionShape2D"):
		enemy.get_node("HitBox/CollisionShape2D").set_deferred("disabled", true)
	# Deactivate HurtBox to stop receiving damage
	if enemy.has_node("HurtBox/CollisionShape2D"):
		enemy.get_node("HurtBox/CollisionShape2D").set_deferred("disabled", true)
	# Deactivate physics collison of the enemy body
	if enemy.has_node("CollisionShape2D"):
		enemy.get_node("CollisionShape2D").set_deferred("disabled", true)

	_direction = enemy.player.global_position.direction_to(enemy.global_position)
	if _direction == Vector2.ZERO:
		_direction = Vector2.DOWN # Direção padrão de segurançaw
	enemy.SetDirection(_direction)
	enemy.velocity = _direction * knockback_speed
	enemy.UpdateAnimation(anim_name)

	if not enemy.animation_player.animation_finished.is_connected(_on_enemy_finished):
		enemy.animation_player.animation_finished.connect(_on_enemy_finished)

func Exit() -> void:
	#enemy.invulnerable = false
	#if enemy.animation_player.animation_finished.is_connected(_on_enemy_finished):
		#enemy.animation_player.animation_finished.disconnect(_on_enemy_finished)
		pass

func Process(_delta : float) -> EnemyState:
	#if _animation_finished:
		#return next_idle_state
	# knockback redution
	enemy.velocity = enemy.velocity.move_toward(Vector2.ZERO, decelarate_speed * 100.0 * _delta)
	#enemy.velocity = enemy.velocity * decelarate_speed * _delta
	return null

func Physics(_delta: float) -> EnemyState:
	return null

func _on_enemy_destroyed( hurt_box : HurtBox) -> void:
	#print("!!! Entering Destroy !!!")
	#print("Called by: ", get_stack())
	_damage_position = hurt_box.global_position
	state_machine.ChangeState(self)

func _on_enemy_finished(_a : String) -> void:
	#_animation_finished = true
	enemy.queue_free()
	pass
