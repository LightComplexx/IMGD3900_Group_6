extends Node

var current_level = 0
var enemy_level = 0

var levels = ["res://scenes/ui/main_menu.tscn", "res://scenes/maps/map01.tscn"]

func main_menu():
	current_level = 0
	enemy_level = 0
	get_tree().change_scene_to_file(levels[current_level])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func next_scene():
	current_level += 1
	if current_level < levels.size():
		get_tree().change_scene_to_file(current_level)
	else:
		main_menu()


func adv_enemy_level():
	enemy_level += 1
	get_tree().change_scene_to_file(levels[1])
