class_name GameCellObject
extends Object


const TO_JSON_PROPERTIES: Array = ["name", "data", "index"]


var _name: String
var _data: GameCellData # Dictionary JSON
var _index: int

## Diferente do _index, que é um displayOrder, o jsonOrder é a ordem do objeto carregado
var order_in_json: int

#    {
#        "name": "Vitaminator",
#        "data": {
#            "key": "vitaminator",
#            "info": "Vitaminator é um jogo da Dasai Studio feito em 10 dias no Unity pra 3ª Jam 2016 - APDJ. Um jogo de sucos e vitaminas suculentas!",
#            "link": "https://dasaistudio.github.io/vitaminator",
#            "target": "_blank",
#            "platform": "PC / Web",
#            "language": "C#",
#            "release": "2016/07/05",
#            "technology": "Unity WebGL"
#        },
#        "index": 2
#    },

##### Built-in methods -----------------------------------------------------------------------------


func _init(each_cell_object: Dictionary):
	_name = each_cell_object.name
	_data = GameCellData.new(each_cell_object.data)
	_index = each_cell_object.index


##### Public methods -------------------------------------------------------------------------------


func to_json() -> String:
	var json_result: String = ""
	json_result += "{"
	
	for json_property in TO_JSON_PROPERTIES:
		json_result += GameCellConstants.TO_JSON_TEMPLATE % [json_property, _get_property_value(json_property)]
	
	# Remove dos valores inteiros as strings demarcadoras "$x$"
	json_result = _get_removed_int_demarker(json_result)
	
	json_result += "}"
	return json_result


##### Private methods ------------------------------------------------------------------------------


func _get_removed_int_demarker(json_result) -> String:
	var left: String = GameCellConstants.DEMARK_INT_LEFT
	var right: String = GameCellConstants.DEMARK_INT_RIGHT
	var forwhat: String = GameCellConstants.REPLACE_INT_DEMARK
	return json_result.replace(left, forwhat).replace(right, forwhat)


## O método quando encontra uma propriedade com valor diferente de valores concatenais, chama o método to_json
func _get_property_value(json_property: String) -> String:
	var property_value = ""
	
	property_value = get("_%s" % json_property)
	
	if typeof(property_value) == TYPE_OBJECT:
		return property_value.to_json()
	
	if typeof(property_value) == TYPE_INT:
		return "$" + str(property_value) + "$"
	
	return str(property_value)
