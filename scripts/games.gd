class_name MainGames
extends Node2D

const game_cell_container_preload = preload("res://scenes/game_cell_container.tscn")


var _game_cells: ScrollContainer
var _game_cell_objects: Array[GameCellObject]


##### Built-in methods -----------------------------------------------------------------------------
 

func _ready():
	_game_cells = get_node("game_cells")
	_game_cells.set_clip_contents(true)
	
	_clean_game_cell_containers()
	_populate_game_cell_objects()


#### Private methods -------------------------------------------------------------------------------


## Lê um arquivo json de game_cells.json
func _load_game_cells() -> Array:
	var path: String = MainGamesConstants.JSON_path
	var filename: String = MainGamesConstants.JSON_filename
	
	var file = FileAccess.open(path + filename, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	
	return data


func _get_cells_container() -> HFlowContainer:
	var cells_container: HFlowContainer = _game_cells.get_node("cells_container")
	return cells_container


## Limpa os game_cell_container do cells_container, para depois dar espaço aos dinâmicos
func _clean_game_cell_containers() -> void:
	var cells_container: HFlowContainer = _get_cells_container()
	for each_child in cells_container.get_children():
		if each_child.name.begins_with("game_cell_container"):
			each_child.queue_free()


func _create_game_cell_containers() -> void:
	var cells_container: HFlowContainer = _get_cells_container()
	for game_cell_object in _game_cell_objects:
		var game_cell_container = game_cell_container_preload.instantiate()
		game_cell_container.name = "game_cell_container_" + str(game_cell_object)
		game_cell_container.setup(game_cell_object)
		cells_container.add_child(game_cell_container)
	
	# Move o botão de adicionar e a margim para últimas posições.
	var add_game_cell_button: TextureButton = cells_container.get_node("add_game_cell_button")
	var margin_bottom: Control = cells_container.get_node("margin_bottom")
	cells_container.move_child(add_game_cell_button, -1)
	cells_container.move_child(margin_bottom, -1)


## Ordena pelo índice (displayOrder)
func _sort_game_cells_by_index() -> void:
	_game_cell_objects.sort_custom(func(a,b): return a._index < b._index)


## Transforma a informação do _load_game_cells em GameCellsData[]
func _populate_game_cell_objects() -> void:
	var raw_data: Array =_load_game_cells()
	var json_order: int = 0
	
	for each_cell in raw_data:
		var game_cell_object: GameCellObject = GameCellObject.new(each_cell)
		game_cell_object.json_order = json_order
		_game_cell_objects.append(game_cell_object)
		json_order += 1
	
	_sort_game_cells_by_index()
	_create_game_cell_containers()
