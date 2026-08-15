extends Control

var score := 0
var time_left := 10.0
var game_running := false

@onready var score_label = $ScoreLabel
@onready var timer_label = $TimerLabel
@onready var click_button = $TargetButton
@onready var result_label = $ResultLabel
@onready var restart_button = $RestartButton


func _ready() -> void:
	score_label.text = "Score: 0"
	timer_label.text = "Time: 10"
	result_label.visible = false
	restart_button.visible = false


func _process(delta: float) -> void:
	if game_running:
		time_left -= delta
		timer_label.text = "Time: " + str(ceil(time_left))

		if time_left <= 0:
			time_left = 0
			game_running = false

			click_button.disabled = true

			timer_label.text = "Time: 0"
			result_label.text = "TIME'S UP!\nFinal Score: " + str(score)

			result_label.visible = true
			restart_button.visible = true


func _on_target_button_pressed() -> void:
	if not game_running:
		game_running = true

	score += 1
	score_label.text = "Score: " + str(score)

	var max_x = size.x - click_button.size.x
	var max_y = size.y - click_button.size.y

	var new_size = max(50, 120 - (score / 5) * 10)

	click_button.size = Vector2(new_size, new_size)

	click_button.position = Vector2(
		randf_range(0, max_x),
		randf_range(80, max_y)
	)

	var tween = create_tween()

	click_button.scale = Vector2(0.8, 0.8)

	tween.tween_property(
		click_button,
		"scale",
		Vector2.ONE,
		0.12
	)


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
