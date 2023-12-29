class_name AddGame
extends CanvasLayer


var accept_button: TextureButton
var cancel_button: TextureButton


##### Built-in methods -----------------------------------------------------------------------------


func _ready():
	accept_button = get_node("accept_button")
	cancel_button = get_node("cancel_button")


##### Public methods -------------------------------------------------------------------------------


func game_cell_object(last_new_index: int) -> GameCellObject:
	var info_game_cell: Dictionary = {
		"name": _get_name(),
		"data": _get_data(),
		"index": last_new_index
	}
	var game_cell_object: GameCellObject = GameCellObject.new(info_game_cell)
	return game_cell_object


##### Private methods ------------------------------------------------------------------------------


func _get_name() -> String:
	var name: String = ""
	var name_input: TextEdit = get_node("panel/inputs/name_input")
	name = name_input.text
	if not name:
		name = name_input.placeholder_text
	return name


func _get_key() -> String:
	var key: String = ""
	var key_input: TextEdit = get_node("panel/inputs/key_input")
	key = key_input.text
	if not key:
		key = key_input.placeholder_text
	return key


func _get_info() -> String:
	var info: String = ""
	var info_input: TextEdit = get_node("panel/inputs/info_input")
	info = info_input.text
	if not info:
		info = info_input.placeholder_text
	return info


func _get_link() -> String:
	var link: String = ""
	var link_input: TextEdit = get_node("panel/inputs/link_input")
	link = link_input.text
	if not link:
		link = link_input.placeholder_text
	return link


func _get_target() -> String:
	var target: String = ""
	var link: String = _get_link()
	
	if link.begins_with("http"):
		target = "_blank"
	
	return target


func _get_platform() -> String:
	var platform: String = ""
	var platform_input: TextEdit = get_node("panel/inputs/platform_input")
	platform = platform_input.text
	if not platform:
		platform = platform_input.placeholder_text
	return platform


func _get_language() -> String:
	var language: String = ""
	var language_input: TextEdit = get_node("panel/inputs/language_input")
	language = language_input.text
	if not language:
		language = language_input.placeholder_text
	return language


func _get_release() -> String:
	var release: String = ""
	var release_input: TextEdit = get_node("panel/inputs/release_input")
	release = release_input.text
	if not release:
		release = release_input.placeholder_text
	return release


func _get_technology() -> String:
	var technology: String = ""
	var technology_input: TextEdit = get_node("panel/inputs/technology_input")
	technology = technology_input.text
	if not technology:
		technology = technology_input.placeholder_text
	return technology




func _get_data() -> Dictionary:
	var data: Dictionary = {
		"key": _get_key(),
		"info": _get_info(),
		"link": _get_link(),
		"target": _get_target(),
		"platform": _get_platform(),
		"language": _get_language(),
		"release": _get_release(),
		"technology": _get_technology(),
	}
	return data
