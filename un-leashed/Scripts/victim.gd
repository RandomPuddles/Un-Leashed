extends RigidBody2D

@export var walkForce: float = 50.0
@onready var sprite: AnimatedSprite2D = $PersonPlaceholderPlaceholderPlaceholder

var targetInterest: Node2D # thing of interest dog is running at

var direction: Vector2
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(onTimeout)
	randTimeStart()
	randomDirection()
	sprite.play("default")

func _physics_process(_delta: float) -> void:
	if linear_velocity.x > 0:
		sprite.flip_h = true
	if linear_velocity.x < 0:
		sprite.flip_h = false
	
	# Continuously apply force in the victim's current direction
	apply_central_force(direction * walkForce)

# Choose a random direction for the dog to wander
func randomDirection() -> void:
	direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()

# Start the timer with a random duration between 2 and 5 seconds
func randTimeStart() -> void:
	timer.start(randf_range(2.0, 5.0))

# Called when the timer finishes
func onTimeout() -> void:
	randomDirection() # Pick a new direction
	randTimeStart() # Restart the timer
