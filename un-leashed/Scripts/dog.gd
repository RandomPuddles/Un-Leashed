class_name Dog
extends RigidBody2D

@onready var detection_area: Area2D = $DetectionArea
@onready var leash_anchor: Marker2D = $LeashAnchor
@onready var biteArea: Area2D = $BiteArea
@onready var biteTimer: Timer = $BiteTimer
var biteTarget: Node2D
@onready var sprite: AnimatedSprite2D = $Sprite2D

@export var biteStartup: float = 1.0
@export var walkForce: float = 50.0
@export var runForce: float = 1000.0
@export var maxSpeed: float = 2000.0

var interested: bool = false # true if the dog is running at a thing of interest
var targetInterest: Node2D # thing of interest dog is running at
var fear: bool = false

var direction: Vector2
@onready var timer: Timer = $Timer

func _ready() -> void:
	detection_area.body_entered.connect(onInterest)
	detection_area.body_exited.connect(onInterestGone)
	biteArea.body_entered.connect(onBiteStart) # Called when interest enters dog's bite range
	biteArea.body_exited.connect(onPossibleBiteTargetExit)
	biteTimer.timeout.connect(onBiteTime)
	timer.timeout.connect(onTimeout)
	randTimeStart()
	randomDirection()
	biteTimer.autostart = false
	biteTimer.one_shot = true
	sprite.play("default")

# Called when interest enters dog's bite range
func onBiteStart(body: Node2D):
	if not body.is_in_group("Interest"):
		return
	if not is_instance_valid(body):
		return
	sprite.play("Eat")
	biteTarget = body
	biteTimer.start(biteStartup)

# Called when it's time for dog to eat interest
func onBiteTime():
	if is_instance_valid(biteTarget):
		biteTarget.queue_free()
	
	sprite.play("default")
	biteTarget = null
	findNewInterest()

func onPossibleBiteTargetExit(body: Node2D):
	if body == biteTarget:
		sprite.play("default")
		biteTarget = null
		targetInterest = null
		interested = false
		fear = false
		biteTimer.stop() # Stops timer before interest is eaten

func _physics_process(_delta: float) -> void:
	if linear_velocity.x > 0:
		sprite.flip_h = false
	if linear_velocity.x < 0:
		sprite.flip_h = true
	if interested and not is_instance_valid(targetInterest):
		findNewInterest()
		return
		# Run at target if interested
	if interested:
		if fear:
			direction = -(targetInterest.global_position - global_position).normalized() # get direction towards target
			apply_central_force(direction * runForce)
		elif linear_velocity.length() < maxSpeed:
			direction = (targetInterest.global_position - global_position).normalized() # get direction towards target
			apply_central_force(direction * runForce)
	# Continuously apply force in the dog's current direction
	elif linear_velocity.length() < maxSpeed:
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

# Called when dog sees thing of interest or uninterest (goon)
func onInterest(body: Node2D):
	# Ignore new interest if already targeting something
	if interested:
		return
	if body.is_in_group("Interest"):
		timer.stop()
		interested = true
		fear = false
		targetInterest = body
	if body.is_in_group("Uninterest"):
		timer.stop()
		interested = true
		fear = true
		targetInterest = body

# Called when interest leaves range. Checks for new interest to run at
func onInterestGone(argbody: Node2D):
	# Ignore if the body that left range isn't the target body
	if argbody != null and argbody != targetInterest:
		return
	findNewInterest()

func findNewInterest():
	interested = false
	fear = false
	targetInterest = null
	
	# Look for new interest in range
	for nodebody in detection_area.get_overlapping_bodies():
		if not is_instance_valid(nodebody) or nodebody.is_queued_for_deletion():
			continue
		if nodebody.is_in_group("Interest") or nodebody.is_in_group("Uninterest"):
			onInterest(nodebody) # dog retargets 
			return
	
	# Resume meandering if no interests remain
	randTimeStart()
	randomDirection()

# If interest touches the dog, the dog instantly eats it (cut directly to chomping part of eat animation), otherwise do full eating animation
