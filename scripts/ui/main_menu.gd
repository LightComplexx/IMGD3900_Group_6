extends Control

func _ready() -> void:
	$MainTheme.play(Globals.song_position)


func _on_play_pressed() -> void:
	Globals.next_scene($MainTheme.get_playback_position() + AudioServer.get_time_since_last_mix())




func _on_help_pressed() -> void:
	Globals.song_position = $MainTheme.get_playback_position() + AudioServer.get_time_since_last_mix()
	get_tree().change_scene_to_file("res://scenes/ui/help_menu.tscn")




func _on_quit_pressed() -> void:
	get_tree().quit()
