class_name Plant extends Node2D

func _ready() -> void:
	$HitBox.Damage.connect(TakeDamage)

# Change the parameters to HurtBox
func TakeDamage(hurt_box: HurtBox) -> void:
	# Exemplo: var damage_val = hurt_box.damage
	queue_free()
