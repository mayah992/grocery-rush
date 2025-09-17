@tool
class_name DialogSystemNode extends CanvasLayer

var is_active : bool = false
@onready var dialogui : Control = $DialogUI
@onready var list : PanelContainer = $DialogUI/list

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		if get_viewport() is Window:
			get_parent().remove_child(self)
			return
		return
	hide_dialog()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _unhandled_input(_event: InputEvent) -> void:
	#if is_active == false:
		#return
	#if event.is_action_pressed("test"):
		#if is_active == false:
			#show_dialog()
		#else:
			#hide_dialog()
	pass
			
func show_list(grocery_list : Array):
	is_active = true
	dialogui.visible = true
	dialogui.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true

	# generate grocery list
	for index in range(grocery_list.size()):
		var frame_id = grocery_list[index]
		var item : Sprite2D = list.get_child(index).get_child(1)
		item.frame = frame_id

func hide_dialog():
	is_active = false
	dialogui.visible = false
	dialogui.process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().paused = false
	pass


func _on_button_pressed() -> void:
	hide_dialog()
