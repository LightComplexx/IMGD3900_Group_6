extends CanvasLayer

@onready var player = $".."

var bar_green = preload("res://sprites/ui/health_bar_green.png")
var bar_yellow = preload("res://sprites/ui/health_bar_yellow.png")
var bar_red = preload("res://sprites/ui/health_bar_red.png")
var bar_texture

var upgrades_selected = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_player_stats(Globals.player_stats["gun_damage"], Globals.player_stats["hp"], Globals.player_stats["tank_speed"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ($UpgradeWindow/move_button.button_pressed or $UpgradeWindow/atk_button.button_pressed or $UpgradeWindow/hp_button.button_pressed):
		$UpgradeWindow/Confirm.show()


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
		


func update_score(score):
	$EnemyInfo/EnemyCount.text = str(score)


func update_level(level):
	$LevelInfo/LevelNum.text = str(level)

func update_player_stats(atk_num, hp_num, spd_num):
	$UpgradeWindow/StatWindow/atk_num.text = str(atk_num)
	$UpgradeWindow/StatWindow/hp_num.text = str(hp_num)
	$UpgradeWindow/StatWindow/spd_num.text = str(spd_num)


func _on_confirm_pressed() -> void:
	if $UpgradeWindow/atk_button.button_pressed:
		Globals.player_stats["gun_damage"] += 5
	if $UpgradeWindow/fire_button.button_pressed:
		Globals.player_stats["gun_cooldown"] -= 0.01
	if $UpgradeWindow/spd_button.button_pressed:
		Globals.player_stats["gun_speed"] += 25
		
	if $UpgradeWindow/hp_button.button_pressed:
		Globals.player_stats["hp"] += 10
	if $UpgradeWindow/move_button.button_pressed:
		Globals.player_stats["tank_speed"] += 20
	if $UpgradeWindow/rotate_button.button_pressed:
		Globals.player_stats["rotate_speed"] += 0.2
	
	update_player_stats(Globals.player_stats["gun_damage"], Globals.player_stats["hp"], Globals.player_stats["tank_speed"])
	upgrades_selected = true
	
