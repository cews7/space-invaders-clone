extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_area_entered(_area: Area2D) -> void:
	animation_player.play("Enemy Death")