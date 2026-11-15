extends RigidBody2D

@onready var detection_area: Area2D = $DetectionArea

@export var walkForce: float = 50.0
@export var runForce: float = 200.0
@export var maxSpeed: float = 2000.0

var interested: bool = false # true if the dog is running at a thing of interest
var targetInterest: Node2D # thing of interest dog is running at

var direction: Vector2
@onready var timer: Timer = $Timer

func _ready() -> void:
	detection_area.body_entered.connect(onInterest)
	detection_area.body_exited.connect(onInterestGone)
	timer.timeout.connect(onTimeout)
	randTimeStart()
	randomDirection()

func _physics_process(_delta: float) -> void:
	if interested and not is_instance_valid(targetInterest):
		interested = false
		targetInterest = null
		randomDirection()
		randTimeStart()
		return
	# Run at target if interested
	if interested and linear_velocity.length() < maxSpeed:
		direction = (targetInterest.global_position - global_position).normalized() # get direction towards target
		apply_central_force(direction * runForce)
	# Continuously apply force in the dog's current direction
	if !interested and linear_velocity.length() < maxSpeed:
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

# Called when dog sees thing of interest
func onInterest(body: Node2D):
	# Ignore new interest if already targeting something
	if body.is_in_group("Dog"):
		timer.stop()
		interested = true
		targetInterest = body

# Called when interest leaves range. Checks for new interest to run at
func onInterestGone(argbody: Node2D):
	# Ignore if the body that left range isn't the target body
	if argbody != targetInterest:
		return
	# Look for new interest in range
	for nodebody in detection_area.get_overlapping_bodies():
		if nodebody is Node2D and nodebody.is_in_group("Dog"):
			onInterest(nodebody) # victim retargets 
			return
	# Resume meandering if no interests remain
	interested = false
	targetInterest = null
	randTimeStart()
	randomDirection()
