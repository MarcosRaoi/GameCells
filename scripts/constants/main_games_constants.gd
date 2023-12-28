class_name MainGamesConstants
extends Node

const JSON_path: String = "C:/Users/Marcos/Desktop/Super Marcos/Portifa/marcosraoi.github.io/json/"
const JSON_filename: String = "game_cells.json"
const img_banner_path: String = "C:/Users/Marcos/Desktop/Super Marcos/Portifa/marcosraoi.github.io/img/banners/"
const img_banner_filename: String = "banner_%s.png"


##### Public methods -------------------------------------------------------------------------------


static func get_json_path() -> String:
	return JSON_path + JSON_filename
