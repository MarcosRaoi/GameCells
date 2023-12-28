class_name GameCellObject
extends Object

var _name: String
var _data: GameCellData # Dictionary JSON
var _index: int

## Diferente do _index, que é um displayOrder, o jsonOrder é a ordem do objeto carregado
var json_order: int

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
