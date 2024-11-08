extends Area2D

@export var speed = 750
@export var damage = 10
@export var lifetime = 0.5

var velocity = Vector2()

func start(pos: Vector2, dir: Vector2):
	position = pos
	rotation = dir.angle()
	$Lifetime.wait_time = lifetime
	velocity = dir * speed
	$Lifetime.start()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta


func explode():
	queue_free()
	


func _on_body_entered(body: Node2D) -> void:
	explode()

func _on_lifetime_timeout() -> void:
	explode()


func _on_area_entered(area: Area2D) -> void:
	explode()
