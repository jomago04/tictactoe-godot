extends Control

# board indicies for every winning line
const LINES := [
	[0, 1, 2], [3, 4, 5], [6, 7, 8],  # rows
	[0, 3, 6], [1, 4, 7], [2, 5, 8],  # columns
	[0, 4, 8], [2, 4, 6],             # diagonals
]

# game state
var board: Array[String] = []
var current_player := "X"
var game_over := false

var cells: Array[Button] = []
var status_label: Label


func _ready() -> void:
	_build_ui()
	_restart()


func _build_ui() -> void:
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 16)
	center.add_child(vbox)

	status_label = Label.new()
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.add_theme_font_size_override("font_size", 28)
	vbox.add_child(status_label)

	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	vbox.add_child(grid)

	for i in 9:
		var cell := Button.new()
		cell.custom_minimum_size = Vector2(100, 100)
		cell.add_theme_font_size_override("font_size", 48)
		# bind(i) passes which button is clicked on the frontend since the signal alone doesnt say
		cell.pressed.connect(_on_cell_pressed.bind(i))
		grid.add_child(cell)
		cells.append(cell)

	var restart_button := Button.new()
	restart_button.text = "Restart"
	restart_button.pressed.connect(_restart)
	vbox.add_child(restart_button)


func _on_cell_pressed(index: int) -> void:
	# ignore clicks after game over or on already claimed cell
	if game_over or board[index] != "":
		return

	board[index] = current_player
	cells[index].text = current_player
	cells[index].disabled = true

	if _check_win(current_player):
		status_label.text = "%s wins!" % current_player
		_end_game()
	elif _check_draw():
		status_label.text = "Draw!"
		_end_game()
	else:
		current_player = "O" if current_player == "X" else "X"
		status_label.text = "%s's turn" % current_player


# Win check
func _check_win(player: String) -> bool:
	# checks player who just moved for a win
	for line in LINES:
		if board[line[0]] == player and board[line[1]] == player and board[line[2]] == player:
			return true
	return false


# Draw check
func _check_draw() -> bool:
	# called after the win check fails
	return not board.has("")


func _end_game() -> void:
	game_over = true
	for cell in cells:
		cell.disabled = true # locks cells after end game


# Restart
func _restart() -> void:
	board.clear()
	board.resize(9)
	board.fill("")
	current_player = "X"
	game_over = false
	for cell in cells:
		cell.text = ""
		cell.disabled = false
	status_label.text = "X's turn"
