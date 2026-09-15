class_name HitBox extends Area2D

signal Damage ( hurt_box : HurtBox )

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func TakeDamege( hurt_box : HurtBox ) -> void:
	print("=== [HITBOX RECEIVED GAMAGE] ===")
	print("HitBox: ", get_parent().name)
	print("Damage Value: ", hurt_box)
	print("Node path: ", get_path())
	print("=============================")
	Damage.emit( hurt_box )
