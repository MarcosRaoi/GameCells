class_name GameCellsContainer
extends Control


var _main
var _game_cell: Control


##### Public methods -------------------------------------------------------------------------------


func setup(game_cell_object: GameCellObject, main) -> void:
	_game_cell = get_node("game_cell")
	_game_cell.set_info_text(game_cell_object._data._info)
	var banner_key: String = game_cell_object._data._key
	_game_cell.set_banner(_load_image_banner(banner_key))
	
	_main = main


func get_cells_container() -> HFlowContainer:
	return get_parent()


func main():
	return _main


##### Private methods ------------------------------------------------------------------------------

func _load_image_banner(banner_key: String) -> Texture2D:
	var path: String = MainGamesConstants.img_banner_path
	var filename: String = MainGamesConstants.img_banner_filename % banner_key
	var filepath: String = path + filename
	
	# Carrega a imagem, e transforma ela em textura
	var image: Image = Image.new()
	var image_resource = image.load_from_file(filepath)
	var image_texture = ImageTexture.new()
	
	return image_texture.create_from_image(image_resource)
