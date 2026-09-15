class_name  HeartGUI extends Control

@onready var sprite: Sprite2D = $Sprite2D


var heart_value : int = 2:
	set( _value ):
		heart_value = _value
		update_sprite( )


func update_sprite( ) ->void:
	sprite.frame = heart_value
