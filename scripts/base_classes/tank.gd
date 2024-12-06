extends CharacterBody2D

# signals used to communicate node states between nodes
signal shoot # handles bullet firing 
signal health_changed # handles any changes to health
signal dead # handles death
signal update_dmg # updates bullet damage
signal update_spd # updates bullet speed

# Export variables are visible/modifiable in the Inspector
# Inspector value takes priority over code value
@export var Bullet:PackedScene
@export var max_speed = 100.0
@export var max_rotation_speed = 2.0
@export var gun_cooldown = 0.4
@export var max_health = 100

# Private tank variables
var can_shoot = true # determines if tank can shoot
var alive = true # determines if health runs out
var health # health variable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health
	emit_signal("health_changed", health * 100/max_health)
	$GunTimer.wait_time = gun_cooldown


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not alive:
		return
	control(delta)

# handles tank controls
func control(_delta: float) -> void:
	pass

# handles damage taken
func take_damage(amount: float) -> void:
	health -= amount
	emit_signal("health_changed", health * 100/max_health)
	if health <= 0:
		explode()

# handles explosion: explosion effects can be added here
func explode() -> void:
	pass

# handles shoot action
func _on_shoot(target = null) -> void:
	if can_shoot:
		can_shoot = false
		$GunTimer.start()
		var dir = Vector2(1, 0).rotated($Turret.global_rotation)
		emit_signal("shoot", Bullet, $Turret/Muzzle.global_position, dir, target)
		
		#$Turret.translate(Vector2(-10,0)) #turret recoil, value is draft
		#TODO: Make the turret return at a set rate
		#TODO: Scale the recoil amount by projectile damage
		

# resets ability to shoot when cooldown ends
func _on_gun_timer_timeout() -> void:
	can_shoot = true


func _on_explosion_animation_finished() -> void:
	queue_free()
