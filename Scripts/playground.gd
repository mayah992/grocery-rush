extends Node2D

# timer variabls
@onready var label = $Label
@onready var timer = $Timer

# item spawing and mechanic variables
@onready var root = $"."
var list_length = 6
var grocery_list = []

var placed_items = []

# try dictionary to keep track of items and number of instances
var grocery_targets : Dictionary = {}
var collected_targets : Dictionary = {}




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# find array length
	grocery_list.resize(list_length)
	# create random list of 6 groceries
	for i in range(6):
		var random_item = randi_range(0, 3)
		grocery_list[i] = random_item
	# print the randomly generated list in consol
	print(grocery_list)
	
	# build target count dictionary
	for id in grocery_list:
		if grocery_targets.has(id):
			grocery_targets[id] += 1
		else:
			grocery_targets[id] = 1
	
	# show the list at beginning of level
	show_list()
	
	# place items
	# Build a list of available node indices
	var available_nodes = []
	for i in range(6, 19): # 6-18 b/c those are the child nodes that are items
		available_nodes.append(i)

# shuffle to randomize
	available_nodes.shuffle()

# place items at unique child positions to ensure required items are there
	for i in range(min(grocery_list.size(), available_nodes.size())):
		var frame_id = grocery_list[i]
		var node_index = available_nodes[i]

		var item_container = root.get_child(node_index)
		if item_container.get_child_count() > 1:
			var placeholder_sprite = item_container.get_child(1)
			if placeholder_sprite is Sprite2D:
				placeholder_sprite.visible = false
		
		var item_scene = preload("res://Scenes/item.tscn")
		var item = item_scene.instantiate()

		item.frame_id = frame_id
		item.get_node("Sprite2D").frame = frame_id
		item.add_to_group("item")  # For player detection
		item.connect("interacted", Callable(self, "_on_item_interacted"))

		item_container.add_child(item)
		item.position = Vector2.ZERO  # center in container
		placed_items.append(node_index)
				
	# fill remaining slots with "decoys"
	var possible_frame_ids = [0, 1, 2, 3]

	for i in range(grocery_list.size(), available_nodes.size()):
		var node_index = available_nodes[i]
		var item_container = root.get_child(node_index)
		if item_container.get_child_count() > 1:
			var placeholder_sprite = item_container.get_child(1)
			if placeholder_sprite is Sprite2D:
				placeholder_sprite.visible = false

		var item_scene = preload("res://Scenes/item.tscn")
		var decoy_item = item_scene.instantiate()

		var random_frame = randi_range(0, possible_frame_ids.size() - 1)
		decoy_item.frame_id = random_frame
		decoy_item.get_node("Sprite2D").frame = random_frame
		decoy_item.add_to_group("item")
		decoy_item.connect("interacted", Callable(self, "_on_item_interacted"))

		item_container.add_child(decoy_item)
		decoy_item.position = Vector2.ZERO

		
	#begin round, timed
	timer.start()

# show list function
func show_list():
	DialogSystem.show_list(grocery_list)

# update text by calculating time left
func time_left():
	var time_left_ = timer.time_left
	var minute = floor(time_left_ /60)
	var seconds = int(time_left_) % 60
	return [minute, seconds]
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# update text
	label.text = "%02d:%02d" % time_left()
	
# when item is interacted with (E)
func _on_item_interacted(frame_id: int):
	# if the grocery list has it listed
	if grocery_targets.has(frame_id):
		# and it hasn't already been collected
		if !collected_targets.has(frame_id):
			# collect
			collected_targets[frame_id] = 1
		else:
			
			collected_targets[frame_id] += 1
		
		# check if list is complete after each interaction
		if _check_win_condition():
			_complete_level()

func _check_win_condition() -> bool:
	for id in grocery_targets.keys():
		if !collected_targets.has(id):
			return false
		if collected_targets[id] < grocery_targets[id]:
			return false
	return true
	
func _complete_level():
	print("Level Complete!")
	# You can stop the timer, show a dialog, or change scene
	timer.stop()
	get_tree().change_scene_to_file("res://Scenes/win.tscn")
	
func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/lose.tscn")
