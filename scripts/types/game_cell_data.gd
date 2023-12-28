class_name GameCellData
extends Object


const TO_JSON_PROPERTIES: Array = [
	"key",
	"info",
	"link",
	"target",
	"platform",
	"language",
	"release",
	"technology"
]


var _key: String
var _info: String
var _link: String
var _target: String = "" # [To open _blank a link, default null]
var _platform: String
var _language: String
var _release: String
var _technology: String


##### Built-in methods -----------------------------------------------------------------------------


func _init(each_cell_data: Dictionary):
	_key = each_cell_data.key
	_info = each_cell_data.info
	_link = each_cell_data.link
	if each_cell_data.has("target"):
		_target = each_cell_data.target
	_platform = each_cell_data.platform
	_language = each_cell_data.language
	_release = each_cell_data.release
	_technology = each_cell_data.technology


##### Public methods -------------------------------------------------------------------------------


func to_json() -> String:
	var json_result: String = ""
	json_result += "{"
	
	for json_property in TO_JSON_PROPERTIES:
		json_result += GameCellConstants.ADD_NEW_LINE_INDENT_JSON
		json_result += GameCellConstants.INDENT_JSON
		
		json_result += GameCellConstants.TO_JSON_TEMPLATE % [json_property, get("_%s" % json_property)]
	
	if json_result.ends_with(","):
		json_result = json_result.trim_suffix(",")
	
	json_result += GameCellConstants.ADD_NEW_LINE_INDENT_JSON
	json_result += GameCellConstants.INDENT_JSON
	
	json_result += "}"
	return json_result
