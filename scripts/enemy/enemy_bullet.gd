extends "res://scripts/base_classes/bullet.gd"

func _ready() -> void:
	damage += (1 * Globals.enemy_level)
	if Globals.enemy_level%5 == 0:
		damage += 5

func _on_area_entered(area: Area2D) -> void:
	# Check if the colliding area is the "BulletDetect" Area2D node
	if area.get_parent().is_in_group("Player"):
		var player = area.get_parent()
		if area.name == "BulletDetect":
			# Ensure the area has a CollisionShape2D named "bullet_collision"
			if area.has_node("bullet_collision"):
				var bullet_shape = area.get_node("bullet_collision") as CollisionShape2D
				if bullet_shape:
					# Assuming the parent of the Area2D has a take_damage method
						if player.has_method("take_damage"):
							player.take_damage(damage)
							player.get_node("DamagedSound").play()
							explode()
