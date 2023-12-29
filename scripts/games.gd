class_name MainGames
extends Node2D

const game_cell_container_preload = preload("res://scenes/game_cell_container.tscn")


var _game_cells: ScrollContainer
var _game_cell_objects: Array[GameCellObject]
var _add_game: AddGame


var someone_is_dragging: bool = false
var last_hovered: int = -1

##### Built-in methods -----------------------------------------------------------------------------
 

func _ready():
	_game_cells = get_node("game_cells")
	_game_cells.set_clip_contents(true)
	
	_clean_game_cell_containers()
	_populate_game_cell_objects()
	
	_add_game = get_node("add_game")
	_hide_add_game()
	
	_connect_add_game_signals()


#### Public methods --------------------------------------------------------------------------------


func game_cells_count() -> int:
	return _game_cell_objects.size()


func cells_container_child_count() -> int:
	return _get_cells_container().get_child_count()


func last_cell_position() -> int:
	return cells_container_child_count() - game_cells_count() + 1

#### Private methods -------------------------------------------------------------------------------


## Lê um arquivo json de game_cells.json
func _load_game_cells() -> Array:
	var file = FileAccess.open(MainGamesConstants.get_json_path(), FileAccess.READ)
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


## Ordena pelo índice (displayOrder) o _game_cell_objects
func _sort_game_cells_by_index() -> void:
	_game_cell_objects.sort_custom(func(a,b): return a._index < b._index)


func _create_game_cell_containers() -> void:
	_sort_game_cells_by_index()
	
	var cell_index: int = 0
	
	var cells_container: HFlowContainer = _get_cells_container()
	for game_cell_object in _game_cell_objects:
		var game_cell_container = game_cell_container_preload.instantiate()
		game_cell_container.name = "game_cell_container_" + str(cell_index)
		game_cell_container.setup(game_cell_object, self)
		cells_container.add_child(game_cell_container)
		cell_index += 1
	
	# Move o botão de adicionar e a margim para últimas posições.
	var add_game_cell_button: TextureButton = cells_container.get_node("add_game_cell_button")
	var margin_bottom: Control = cells_container.get_node("margin_bottom")
	cells_container.move_child(add_game_cell_button, -1)
	cells_container.move_child(margin_bottom, -1)


## Transforma a informação do _load_game_cells em GameCellsData[]
func _populate_game_cell_objects() -> void:
	var raw_data: Array =_load_game_cells()
	var order_in_json: int = 0
	
	for each_cell in raw_data:
		var game_cell_object: GameCellObject = GameCellObject.new(each_cell)
		game_cell_object.order_in_json = order_in_json
		_game_cell_objects.append(game_cell_object)
		order_in_json += 1
	
	_create_game_cell_containers()


## Já que as células de jogos podem ter sido reordenadas, atualiza as
## propriedades _index nos _game_cells_objects pra gerar
func _update_cells_index_data() -> void:
	var cells_container: HFlowContainer = _get_cells_container()
	var cell_index: int = 0
	
	for game_cell_object in _game_cell_objects:
		var game_cell_container = cells_container.get_node("game_cell_container_" + str(cell_index))
		game_cell_object.set_index(game_cell_container.get_index())
		
		cell_index += 1


func _store_json(json_result) -> void:
	var path: String = MainGamesConstants.get_json_path()
	print("Storing json at...\n", path, "\n")
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(json_result)
	
	# Salva um JSON no projeto também
	file = FileAccess.open("res://json/game_cells.json", FileAccess.WRITE)
	file.store_string(json_result)


func _show_add_game() -> void:
	_add_game.show()


func _hide_add_game() -> void:
	_add_game.hide()


func _connect_add_game_signals() -> void:
	var _on_accept_button_down: Callable = Callable(self, "_on_accept_button_down")
	_add_game.accept_button.button_down.connect(_on_accept_button_down)
	
	var _on_cancel_button_down: Callable = Callable(self, "_on_cancel_button_down")
	_add_game.cancel_button.button_down.connect(_on_cancel_button_down)


func _add_game_cell() -> void:
	var last_new_index: int = _game_cell_objects.size()
	var game_cell_object: GameCellObject = _add_game.game_cell_object(last_new_index)
	_game_cell_objects.append(game_cell_object)
	var cells_container: HFlowContainer = _get_cells_container()
	var game_cell_container = game_cell_container_preload.instantiate()
	
	game_cell_container.name = "game_cell_container_" + str(game_cells_count() - 1)
	game_cell_container.setup(game_cell_object, self)
	cells_container.add_child(game_cell_container)
	cells_container.move_child(game_cell_container, - last_cell_position())


##### Signal methods -------------------------------------------------------------------------------


func _on_accept_button_down() -> void:
	_add_game_cell()


func _on_cancel_button_down() -> void:
	_hide_add_game()


## Função para gerar JSON, ela ordena o _game_cells_objects na "order_in_json"
## identa o resultado JSON chamando as .to_json() das GameCells e passa o resultado para _store_json() 
func _on_json_generate_button_button_down():
	# Atualiza as propriedades "_index"
	_update_cells_index_data()
	
	# Ordena de volta para a ordem de publicação no game_cells.json
	var game_cells_json: Array[GameCellObject] = _game_cell_objects.duplicate()
	game_cells_json.sort_custom(func(a,b): return a.order_in_json < b.order_in_json)
	
	var json_result: String = ""
	
	json_result += "["
	json_result += GameCellConstants.ADD_NEW_LINE_INDENT_JSON
	
	for game_cell_object in game_cells_json:
		json_result += game_cell_object.to_json()
		json_result += GameCellConstants.ADD_NEW_LINE_INDENT_JSON
	
	if json_result.ends_with(",\n    "):
		json_result = json_result.trim_suffix(",\n    ")
	
	json_result += "\n]"
	
	_store_json(json_result)


func _on_add_game_cell_button_button_down():
	_show_add_game()
