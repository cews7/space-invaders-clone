class_name BaseEnemy extends Area2D


var reload_time : float
var is_reload_time_complete : bool

func _ready() -> void:
	reload_time = 0


func is_able_to_shoot(delta: float) -> bool:
	return reload_time_elapsed(delta) and reload_attempt_successful() and has_line_of_sight()
		

func reload_time_elapsed(delta: float) -> bool:
	if reload_time >= 1:
		is_reload_time_complete = true
		reload_time = 0
	else:
		is_reload_time_complete = false
	reload_time += delta
	return is_reload_time_complete


func reload_attempt_successful() -> bool:
	var num: int = 1
	var rand_num: int = randi_range(0, 17)
	if num == rand_num:
		return true
	return false


func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		get_parent().show_game_over()


func has_line_of_sight() -> bool:
	return not $LOSCheck.is_colliding()
