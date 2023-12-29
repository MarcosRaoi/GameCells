class_name Draggable
extends TextureButton

@export var _draggable_element_path: NodePath = ".."

const DEFAULT_DROPABLE_AREA_COLOR = Color(0.2, 0.25, 0.0, 0.4)


var _is_dragging: bool = false
var _draggable_element

var _offset: Vector2
var _last_index: int
var _initial_position: Vector2

var _main
var _game_cell_container: GameCellsContainer

##### Built-in methods ----------------------------------------------------------------------------- 


func _ready():
	set_process(false)
	_draggable_element = get_node(_draggable_element_path)
	_game_cell_container = get_parent()
	_main = _game_cell_container.main()


func _process(_delta):
	if _is_dragging:
		_move_draggable_element()


##### Private methods ------------------------------------------------------------------------------


func _move_draggable_element() -> void:
	var position: Vector2 = get_global_mouse_position() - _offset
	
	#_draggable_element.global_position = position
	#global_position = position
	
	_game_cell_container.global_position = position


func _bring_to_top(is_dragging: bool) -> void:
	var cells_container = _game_cell_container.get_cells_container()
	if is_dragging:
		var last_position: int = _main.last_cell_position()
		cells_container.move_child(_game_cell_container, - last_position)
	else:
		cells_container.move_child(_game_cell_container, _main.last_hovered)


func _feedback_dropable_area_dragging(is_dragging: bool) -> void:
	var dropable_area = _game_cell_container.get_node_or_null("dropable_area")
	if not dropable_area:
		return
	
	if is_dragging:
		dropable_area.color = Color.DARK_GOLDENROD
	else:
		dropable_area.color = DEFAULT_DROPABLE_AREA_COLOR


func _feedback_dropable_area_hovering(is_hovering: bool) -> void:
	var dropable_area = _game_cell_container.get_node_or_null("dropable_area")
	if not dropable_area:
		return
	
	if is_hovering and _main.someone_is_dragging:
		dropable_area.color = Color.WEB_GREEN
		if _main:
			_main.last_hovered = _game_cell_container.get_index()
	else:
		dropable_area.color = DEFAULT_DROPABLE_AREA_COLOR


func _is_hover() -> bool:
	return (
		get_global_mouse_position().x >= get_global_rect().position.x and 
		get_global_mouse_position().x <= get_global_rect().position.x + get_global_rect().size.x and
		get_global_mouse_position().y >= get_global_rect().position.y and 
		get_global_mouse_position().y <= get_global_rect().position.y + get_global_rect().size.y
	)


##### Signal methods -------------------------------------------------------------------------------


func _on_button_down():
	_is_dragging = true
	_main.someone_is_dragging = true
	
	_initial_position = _game_cell_container.global_position
	
	_offset = get_global_mouse_position() - _game_cell_container.global_position
	_last_index = _game_cell_container.get_index()
	
	_bring_to_top(_is_dragging)
	_feedback_dropable_area_dragging(_is_dragging)


func _on_button_up():
	_is_dragging = false
	_main.someone_is_dragging = false
	
	_game_cell_container.global_position = _initial_position
	
	_bring_to_top(_is_dragging)
	_feedback_dropable_area_dragging(_is_dragging)


func _on_mouse_entered():
	set_process(true)


func _on_mouse_exited():
	set_process(false)


func _unhandled_input(event):
	# Só queremos tratar o hovers de quem não está sendo Dragging
	if _is_dragging:
		return
	
	_feedback_dropable_area_hovering(_is_hover())
