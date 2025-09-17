class_name Player extends CharacterBody2D

# movement variables, figured out with help of youtube tutorial
var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
#animation variables
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine

# item interaction variable
var current_item: Area2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# initialize state machine
	state_machine.Initialize(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	# apply direction of movement / allow diagonal movement
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
# called every physics frame, collision checks, inputs
func _physics_process(_delta: float) -> void:
	# if interact key is pressed (E)
	if Input.is_action_just_pressed("interact"): 
		# if there is an item
		if current_item != null:
			# get item's frame id
			var frame_id = current_item.frame_id
			
			var main_scene = get_tree().current_scene
			# if item is in grocery_targets and max collected or not in grocery_targets
			if (main_scene.grocery_targets.has(frame_id) and
				main_scene.collected_targets.get(frame_id, 0) >= main_scene.grocery_targets[frame_id]) \
				or not main_scene.grocery_targets.has(frame_id):
				# slow player down
				
				# don't pick up the item
				print("item not on list or item quota already met.")
			# else it can be picked up and is removed from scene
			else:
				current_item.emit_signal("interacted", frame_id)
				current_item.queue_free()
	# DON'T KNOW WHAT THIS DOES, JUST WAS IN TUTORIAL
	move_and_slide()

# Find Direction function
func SetDirection () -> bool:
	var new_direction : Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
	
	if direction.y == 0:
		new_direction = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_direction = Vector2.UP if direction.y < 0 else Vector2.DOWN
		
	if new_direction == cardinal_direction:
		return false
	
	cardinal_direction = new_direction
	return true
	
# Update animation
func UpdateAnimation(state : String) -> void:
	animation_player.play(state + "_" + AnimDirection())
	pass
	
# Decide direction of animation
func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	elif cardinal_direction == Vector2.RIGHT:
		return "right"
	else:
		return "left"

# if area is entered
func _on_area_2d_area_entered(area: Area2D) -> void:
	# if the area that entered is an item
	if area.is_in_group("item"):
		# log as the current item
		current_item = area

# when area is exited, return current item to null
func _on_area_2d_area_exited(area: Area2D) -> void:
	if area == current_item:
		current_item = null
