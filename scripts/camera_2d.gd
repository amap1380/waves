extends Camera2D


#//// type 1 screen shake
@export_category("Type 1")
@export var decay : float = 0.8 # Time it takes to reach 0% of trauma
@export var max_offset : Vector2 = Vector2(100, 75) # Max hor/ver shake in pixels
@export var max_roll : float = 0.1 # Maximum rotation in radians (use sparingly)

var trauma : float = 0.0 # Current shake strength
var trauma_power : int = 2 # Trauma exponent. Increase for more extreme shaking

#/// type 2 screen shake

@export_category("Type 2")

var shake_intensity: float = 0.0
var active_shake_time: float = 0.0

@export var shake_decay: float = 5.0

var shake_time: float = 0.0
@export var shake_time_speed: float = 20.0

var noise = FastNoiseLite.new()

var shake_rng = RandomNumberGenerator.new()


func _ready() -> void:
	#? Randomize the game seed
	shake_rng.randomize()


func _physics_process(delta: float) -> void:
	if active_shake_time > 0:
		shake_time += shake_time_speed * delta
		offset.x = noise.get_noise_2d(shake_time, 0) * shake_intensity
		offset.y = noise.get_noise_2d(0, shake_time) * shake_intensity
		
		shake_intensity = max(shake_intensity - shake_decay * delta, 0)
	else:
		offset = lerp(offset, Vector2.ZERO, 10.5*delta)
	if trauma: # If the camera is currently shaking
		trauma = max(trauma - decay * delta, 0) # Decay the shake strength
		shake() # Shake the camera


func screen_shake(intensity: float, time: float):
	shake_rng.randomize()
	noise.seed = shake_rng.randi()
	noise.frequency = 2.0
	
	shake_intensity = intensity
	active_shake_time = time
	shake_time = 0.0




## The function to use for adding trauma (screen shake)
func add_trauma(amount : float) -> void:
	trauma = min(trauma + amount, 1.0) # Add the amount of trauma (capped at 1.0)

## This function is used to actually apply the shake to the camera
func shake() -> void:
	#? Set the camera's rotation and offset based on the shake strength
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)
