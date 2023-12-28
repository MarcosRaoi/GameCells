class_name GameCell
extends Control

var _banner: TextureRect
var _info_text: Label


##### Public methods -------------------------------------------------------------------------------


func set_info_text(info_text: String) -> void:
	_info_text = get_node("info/info_text")
	_info_text.set_text(info_text)


func set_banner(texture: Texture2D) -> void:
	_banner = get_node("banner")
	_banner.texture = texture
