extends Control

@onready var title_label: Label = $TitleLabel
@onready var game_2048_button: Button = $Game2048button
@onready var quick_click_button: Button = $QuickClickButton


func _ready() -> void:
	await get_tree().process_frame
	var center_x = size.x / 2
	
	style_title()
	style_button(game_2048_button)
	style_button(quick_click_button)
	title_label.position.x = center_x - title_label.size.x / 2
	title_label.position.y = 100

	game_2048_button.position.x = center_x - game_2048_button.size.x / 2
	game_2048_button.position.y = 250

	quick_click_button.position.x = center_x - quick_click_button.size.x / 2
	quick_click_button.position.y = 330


func style_title() -> void:
	title_label.add_theme_font_size_override("font_size", 52)
	title_label.add_theme_color_override("font_color", Color.WHITE)
	title_label.add_theme_color_override("font_outline_color", Color.BLACK)
	title_label.add_theme_constant_override("outline_size", 8)


func style_button(button: Button) -> void:
	button.custom_minimum_size = Vector2(300, 70)

	button.add_theme_font_size_override("font_size", 28)
	button.add_theme_color_override("font_color", Color.WHITE)
	button.add_theme_color_override("font_hover_color", Color.WHITE)
	button.add_theme_color_override("font_pressed_color", Color.WHITE)

	var normal = StyleBoxFlat.new()
	normal.bg_color = Color("#25253A")
	normal.corner_radius_top_left = 16
	normal.corner_radius_top_right = 16
	normal.corner_radius_bottom_left = 16
	normal.corner_radius_bottom_right = 16
	normal.content_margin_left = 20
	normal.content_margin_right = 20

	var hover = normal.duplicate()
	hover.bg_color = Color("#3A3A5C")

	var pressed = normal.duplicate()
	pressed.bg_color = Color("#171725")

	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)


func _on_quick_click_pressed():
	get_tree().change_scene_to_file("res://QuickClick.tscn")


func _on_game_2048_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Main.tscn") # Replace with function body.
