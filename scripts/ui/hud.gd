extends CanvasLayer

var bar_green = preload("res://sprites/ui/health_bar_green.png")
var bar_yellow = preload("res://sprites/ui/health_bar_yellow.png")
var bar_red = preload("res://sprites/ui/health_bar_red.png")
var bar_texture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_healthbar(value) -> void:
	bar_texture = bar_green
	
	if value < 100:
		$AnimationPlayer.play("healthbar_flash")
	if value < 60:
		bar_texture = bar_yellow
	if value < 25:
		bar_texture = bar_red
	
	$Margin/Container/HealthBar.texture_progress = bar_texture
	
	var tween := get_tree().create_tween()
	tween.tween_property($Margin/Container/HealthBar, "value", value, 0.2)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "healthbar_flash":
		$Margin/Container/HealthBar.texture_progress = bar_texture
