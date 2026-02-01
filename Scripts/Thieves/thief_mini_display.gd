class_name ThiefMiniDisplay
extends Button

var thief: Thief
@export var mask_texture2D: TextureRect
@export var name_label: Label
@export var work_panel: PanelContainer
@export var work_label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mask_texture2D.texture = thief.mask
	mask_texture2D.modulate = thief.color
	name_label.text = thief.name
	work_panel.visible = false
	mouse_entered.connect(_on_mouse_entered.bind())

func _on_mouse_entered() -> void:
	grab_focus();
