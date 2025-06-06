extends "res://scripts/base_classes/bullet.gd"

var base_gun = preload("res://sprites/tank_guns/single_gunonly_pixel.png")
var big_gun = preload("res://sprites/tank_guns/big_gun.png")

func _ready() -> void:
	var player_node = get_parent().get_node("Player")
	
	if player_node.get_node("Turret").texture == base_gun:
		damage = Globals.player_stats["gun_damage"]
		speed = Globals.player_stats["gun_speed"]
	if player_node.get_node("Turret").texture == big_gun:
		damage = Globals.player_stats["gun_damage"] + 30
		speed = Globals.player_stats["gun_speed"]
	

func _on_area_entered(area: Area2D) -> void:
	# Check if the colliding area is the "BulletDetect" Area2D node
	if area.name == "BulletDetect" and area.get_parent().is_in_group("Enemy"):
		# Ensure the area has a CollisionShape2D named "bullet_collision"
		if area.has_node("bullet_collision"):
			var bullet_shape = area.get_node("bullet_collision") as CollisionShape2D
			if bullet_shape:
				# Assuming the parent of the Area2D has a take_damage method
				if area.get_parent().has_method("take_damage"):
					area.get_parent().take_damage(damage)
					area.get_parent().get_node("DamagedSound").play()
					explode()
	if area.name == "BodyDetection" and area.get_parent().is_in_group("Enemy"):
		if area.has_node("detection_shape"):
			var bullet_shape = area.get_node("detection_shape") as CollisionPolygon2D
			if bullet_shape:
				if area.get_parent().has_method("take_damage"):
					area.get_parent().take_damage(damage)
					area.get_parent().get_node("DamagedSound").play()
					explode()
