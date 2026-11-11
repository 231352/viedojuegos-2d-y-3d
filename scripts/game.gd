extends Node2D

enum GameState { MENU, RANKINGS, PLAYING, PAUSED, LEVEL_CLEAR, GAME_OVER, VICTORY }

const PLAYER_SCRIPT := preload("res://scripts/player.gd")
const COIN_SCRIPT := preload("res://scripts/coin.gd")
const ENEMY_SCRIPT := preload("res://scripts/enemy.gd")
const HAZARD_SCRIPT := preload("res://scripts/hazard.gd")
const GOAL_SCRIPT := preload("res://scripts/goal.gd")
const COIN_SOUND: AudioStream = preload("res://assets/audio/coin.wav")
const ENEMY_STOMP_SOUND: AudioStream = preload("res://assets/audio/enemy_stomp.wav")
const BACKGROUND_MUSIC: AudioStream = preload("res://assets/audio/background_music.wav")
const PLAYER_FALL_SOUND: AudioStream = preload("res://assets/audio/player_fall.wav")
const LEVEL_CLEAR_SOUND: AudioStream = preload("res://assets/audio/level_clear.wav")
const VICTORY_SOUND: AudioStream = preload("res://assets/audio/victory.wav")
const DUNGEON_BACKGROUND: Texture2D = preload("res://assets/four_seasons/background_/dungeon_.png")
const OBJECTS_ATLAS: Texture2D = preload("res://assets/four_seasons/objects_/staticObjects_.png")
const TILE_TOP_GRASS := Rect2(16.0, 32.0, 16.0, 16.0)
const TILE_FILL_DIRT := Rect2(64.0, 48.0, 16.0, 16.0)
const TILE_TOP_STONE := Rect2(48.0, 80.0, 16.0, 16.0)
const TILE_FILL_STONE := Rect2(64.0, 112.0, 16.0, 16.0)
const TILE_TOP_ORANGE := Rect2(48.0, 176.0, 16.0, 16.0)
const TILE_FILL_ORANGE := Rect2(64.0, 208.0, 16.0, 16.0)
const LEVELS := [
	{
		"title": "Pradera de primavera",
		"season": "spring",
		"length": 1280,
		"tile_scale": 2.75,
		"spawn": [100, 330],
		"goal_y": 450,
		"show_goal": true,
		"ground": [[0, 496, 4, 2, 3], [220, 480, 2, 3, 3], [352, 484, 3, 3, 4], [528, 484, 3, 3, 3], [660, 455, 3, 3, 4], [792, 515, 2, 2, 3], [880, 455, 3, 3, 4], [1012, 484, 4, 3, 3], [1188, 484, 2, 2, 0]],
		"platforms": [[44, 440, 2, 2, 0], [88, 352, 2, 2, 0], [132, 286, 2, 2, 0], [176, 308, 1, 2, 0], [176, 264, 2, 2, 0], [220, 208, 3, 3, 0], [264, 208, 2, 2, 0], [352, 246, 1, 2, 1], [396, 232, 2, 2, 0], [440, 352, 1, 2, 1], [484, 352, 2, 2, 1], [528, 396, 2, 2, 0], [572, 468, 2, 2, 4], [650, 396, 2, 3, 0], [738, 396, 2, 2, 0], [704, 220, 4, 3, 0], [792, 220, 2, 2, 0], [836, 264, 2, 2, 0], [880, 352, 2, 2, 1], [924, 220, 2, 2, 4], [1012, 286, 2, 2, 0], [1056, 220, 3, 2, 0], [1100, 264, 2, 2, 4], [1144, 220, 2, 2, 0], [1100, 396, 2, 2, 0]],
		"coins": [[58, 250], [18, 390], [190, 430], [322, 430], [582, 245], [760, 345], [890, 385], [928, 235], [1190, 455]],
		"enemies": [[500, 338, 484, 560, 75], [245, 194, 220, 330, 75], [690, 375, 650, 735, 85], [950, 338, 930, 1000, 95], [1220, 462, 1190, 1260, 105]],
		"hazards": [],
		"bridges": [[475, 700, 286], [870, 1000, 286]],
		"decorations": [[130, 270, 16, 16, 16, 40], [220, 208, 128, 16, 16, 16], [302, 208, 32, 16, 16, 16], [396, 232, 32, 64, 16, 16], [500, 308, 128, 16, 16, 16], [585, 468, 16, 16, 16, 40], [730, 220, 32, 64, 16, 16], [820, 248, 80, 16, 16, 24], [930, 220, 32, 64, 16, 16], [1080, 220, 32, 16, 16, 16], [1190, 220, 16, 16, 16, 44], [830, 484, 0, 80, 32, 16], [930, 484, 64, 64, 32, 32], [1060, 484, 0, 80, 32, 16]]
	},
	{
		"title": "Cañón del verano",
		"season": "summer",
		"length": 1280,
		"tile_scale": 2.75,
		"spawn": [32, 500],
		"goal_y": 445,
		"show_goal": true,
		"fall_y": 640,
		"ground": [[0, 520, 3, 2, 3], [176, 535, 2, 2, 0], [308, 510, 2, 3, 1], [396, 470, 4, 2, 4], [572, 470, 3, 2, 1], [704, 480, 2, 2, 0], [792, 450, 4, 3, 1], [968, 450, 3, 2, 4], [1100, 480, 4, 2, 0]],
		"platforms": [[44, 440, 2, 2, 0], [44, 308, 1, 2, 0], [88, 352, 2, 2, 0], [88, 308, 2, 2, 0], [132, 308, 1, 2, 0], [176, 330, 2, 3, 1], [220, 364, 2, 2, 0], [264, 400, 2, 2, 1], [220, 220, 3, 2, 0], [308, 242, 2, 2, 0], [352, 252, 2, 2, 0], [352, 440, 2, 2, 1], [396, 396, 2, 2, 0], [440, 352, 2, 2, 0], [440, 440, 2, 2, 0], [484, 396, 2, 2, 0], [528, 440, 2, 2, 1], [572, 396, 2, 2, 0], [616, 370, 2, 2, 0], [660, 310, 3, 2, 0], [704, 230, 4, 2, 0], [704, 352, 2, 2, 1], [748, 310, 2, 2, 0], [792, 310, 3, 2, 0], [792, 370, 2, 2, 1], [836, 320, 2, 2, 0], [880, 360, 2, 2, 1], [924, 310, 2, 2, 0], [1012, 242, 4, 2, 0], [968, 285, 2, 2, 0], [1012, 350, 2, 2, 1], [1056, 220, 3, 2, 0], [1056, 305, 2, 2, 0], [1100, 220, 3, 2, 0], [1100, 308, 2, 2, 0], [1144, 310, 3, 2, 0]],
		"coins": [[24, 385], [360, 375], [615, 255], [920, 310], [1085, 300], [1170, 465]],
		"enemies": [[105, 302, 82, 126, 100, "b83c86"], [240, 208, 224, 286, 110, "d65a32"], [377, 428, 354, 390, 115, "d65a32"], [575, 428, 548, 610, 120, "a748a8"], [696, 358, 620, 700, 125, "d65a32"], [955, 298, 930, 1000, 130, "54a93b"], [1020, 230, 1012, 1095, 140, "d65a32"], [996, 438, 975, 1040, 135, "d65a32"], [1170, 300, 1146, 1240, 145, "b83c86"]],
		"hazards": [],
		"bridges": [[475, 700, 286], [870, 1000, 286]],
		"decorations": [[108, 316, 48, 16, 32, 48, 2.75, 2.75], [58, 308, 32, 16, 16, 16], [270, 220, 64, 64, 32, 16], [400, 252, 64, 64, 32, 16], [285, 400, 0, 80, 32, 16], [488, 440, 48, 16, 32, 48, 2.75, 2.75], [748, 310, 48, 16, 32, 48, 2.75, 3.5], [860, 310, 0, 80, 32, 16], [1044, 450, 48, 16, 32, 48, 2.75, 4.75], [1060, 450, 64, 64, 32, 16], [1160, 236, 48, 16, 32, 48, 2.75, 2.75], [1188, 480, 16, 16, 16, 32], [1250, 520, 48, 16, 32, 48, 2.75, 2.75]]
	},
	{
		"title": "Fortaleza de las sombras",
		"season": "dungeon",
		"length": 1280,
		"tile_scale": 2.5,
		"spawn": [74, 470],
		"goal_x": 1050,
		"goal_y": 420,
		"show_goal": true,
		"fall_y": 620,
		"ground": [[32, 494, 3, 3, 1], [160, 548, 7, 2, 1, 66], [323, 536, 3, 2, 1, 78], [496, 548, 2, 2, 1, 66], [832, 492, 11, 3, 1]],
		"platforms": [[80, 340, 1, 1, 1], [200, 294, 2, 1, 1], [362, 358, 1, 1, 1], [497, 454, 2, 1, 1], [539, 294, 2, 1, 1], [572, 378, 1, 1, 1], [661, 358, 3, 1, 1], [863, 382, 2, 1, 1], [1026, 282, 1, 1, 1], [1152, 318, 2, 1, 1], [1152, 410, 1, 1, 1], [220, 108, 2, 1, 1], [271, 108, 1, 1, 1], [366, 180, 1, 1, 1], [863, 180, 2, 1, 1], [1027, 105, 1, 1, 1], [1152, 145, 2, 1, 1], [1012, 452, 2, 2, 1]],
		"coins": [[97, 300], [385, 316], [592, 320], [758, 495], [1045, 235], [1172, 360], [1258, 350]],
		"enemies": [[190, 525, 168, 245, 145], [420, 525, 390, 440, 155], [550, 278, 530, 600, 160], [680, 338, 655, 720, 165], [850, 475, 832, 930, 170], [970, 475, 920, 1000, 175], [1110, 475, 1060, 1190, 180], [1210, 306, 1180, 1232, 190]],
		"hazards": [],
		"chains": [[500, 160, 614], [539, 160, 300], [539, 432, 520], [597, 160, 278], [597, 298, 520], [640, 160, 500], [674, 160, 235], [723, 352, 435], [764, 160, 340], [764, 478, 614]],
		"dungeon_doors": [[86, 494, 3.0]],
		"decorations": [[58, 494, 0, 80, 16, 16], [170, 548, 0, 80, 16, 16], [290, 548, 0, 80, 16, 16], [420, 548, 0, 80, 16, 16], [830, 492, 0, 80, 16, 16], [965, 492, 0, 80, 16, 16], [1230, 492, 0, 80, 16, 16]]
	}
]

const PALETTE := {
	"spring": {"sky": Color("8fd8de"), "horizon": Color("b9e6bf"), "far": Color("78b89a"), "near": Color("57917f"), "sun": Color("ffe69a"), "enemy": Color("df7e68"), "hazard": Color("dc705e")},
	"summer": {"sky": Color("79cbe4"), "horizon": Color("f1d79b"), "far": Color("b3a568"), "near": Color("7e8553"), "sun": Color("fff0a5"), "enemy": Color("c56d47"), "hazard": Color("dd644c")},
	"autumn": {"sky": Color("708db5"), "horizon": Color("e7ae82"), "far": Color("b8796c"), "near": Color("765969"), "sun": Color("ffd37e"), "enemy": Color("a95860"), "hazard": Color("d86355")},
	"winter": {"sky": Color("6c9bc1"), "horizon": Color("c0ddec"), "far": Color("9cb7cd"), "near": Color("6e8ea9"), "sun": Color("fff4d6"), "enemy": Color("588db4"), "hazard": Color("74c8dd")},
	"dungeon": {"sky": Color("071b26"), "horizon": Color("171a20"), "far": Color("2b292b"), "near": Color("393235"), "sun": Color("ffd052"), "enemy": Color("bd543c"), "hazard": Color("d9441d")}
}

var state := GameState.MENU
var current_level_index := 0
var current_config: Dictionary = {}
var world_width := 1280
var platform_tile_scale := 3.0
var world_container: Node2D
var player
var spawn_point := Vector2(88.0, 545.0)
var player_name := ""
var player_name_input: LineEdit
var name_hint: Label
var lives := 3
var score := 0
var level_coins := 0
var elapsed_seconds := 0.0
var max_level_reached := 1
var run_saved := false
var ui_layer: CanvasLayer
var ui_root: Control
var hud_level_label: Label
var hud_score_label: Label
var hud_lives_label: Label
var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	world_container = Node2D.new()
	world_container.name = "World"
	world_container.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(world_container)
	ui_layer = CanvasLayer.new()
	ui_layer.name = "Interface"
	ui_layer.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(ui_layer)
	ui_root = Control.new()
	ui_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ui_root.mouse_filter = Control.MOUSE_FILTER_PASS
	ui_layer.add_child(ui_root)
	music_player = AudioStreamPlayer.new()
	music_player.name = "BackgroundMusic"
	music_player.stream = BACKGROUND_MUSIC
	music_player.volume_db = -17.0
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(music_player)
	music_player.play()
	sfx_player = AudioStreamPlayer.new()
	sfx_player.name = "SoundEffects"
	sfx_player.volume_db = -7.0
	sfx_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(sfx_player)
	_show_menu()


func _process(delta: float) -> void:
	if state == GameState.PLAYING:
		elapsed_seconds += delta
		if is_instance_valid(player) and player.global_position.y > float(current_config.get("fall_y", 820.0)):
			_hurt_player()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		if state == GameState.PLAYING:
			_pause_game()
			get_viewport().set_input_as_handled()
		elif state == GameState.PAUSED:
			_resume_game()
			get_viewport().set_input_as_handled()


func _draw() -> void:
	var season := "spring"
	if not current_config.is_empty():
		season = str(current_config.get("season", "spring"))
	var colors: Dictionary = PALETTE[season]
	if current_level_index == 0 and not current_config.is_empty():
		draw_rect(Rect2(0.0, 0.0, float(world_width), 9.0), Color("102632"))
		draw_rect(Rect2(0.0, 9.0, float(world_width), 115.0), Color("f8fbff"))
		draw_rect(Rect2(0.0, 124.0, float(world_width), 218.0), Color("079bd1"))
		draw_rect(Rect2(0.0, 342.0, float(world_width), 178.0), Color("2454ad"))
		draw_rect(Rect2(0.0, 520.0, float(world_width), 85.0), Color("211e5d"))
		draw_rect(Rect2(0.0, 605.0, float(world_width), 57.0), Color("119dcc"))
		_draw_rope_line(124.0, Color("079bd1"))
		_draw_rope_line(342.0, Color("087fc0"))
		_draw_log_bridge(475.0, 700.0, 286.0)
		_draw_log_bridge(870.0, 1000.0, 286.0)
		return
	if current_level_index == 1 and not current_config.is_empty():
		draw_rect(Rect2(0.0, 0.0, float(world_width), 8.0), Color("30263b"))
		draw_rect(Rect2(0.0, 8.0, float(world_width), 108.0), Color("fff13b"))
		draw_rect(Rect2(0.0, 116.0, float(world_width), 224.0), Color("ffc32b"))
		draw_rect(Rect2(0.0, 340.0, float(world_width), 172.0), Color("ff7908"))
		draw_rect(Rect2(0.0, 512.0, float(world_width), 96.0), Color("bb2b15"))
		draw_rect(Rect2(0.0, 608.0, float(world_width), 54.0), Color("a51c83"))
		_draw_rope_line(116.0, Color("ffd844"))
		_draw_rope_line(340.0, Color("ff9d24"))
		_draw_rope_line(512.0, Color("e84b21"))
		_draw_log_bridge(475.0, 700.0, 286.0)
		_draw_log_bridge(870.0, 1000.0, 286.0)
		_draw_log_bridge(0.0, 52.0, 545.0)
		_draw_log_bridge(1236.0, 1280.0, 545.0)
		_draw_ladder(640.0, 370.0, 520.0)
		return
	if current_level_index == 2 and not current_config.is_empty():
		draw_rect(Rect2(0.0, 0.0, float(world_width), 662.0), Color("071b26"))
		for y in range(144, 614, 40):
			for x in range(32, world_width - 32, 40):
				draw_texture_rect_region(DUNGEON_BACKGROUND, Rect2(float(x), float(y), 40.0, 40.0), Rect2(0.0, 0.0, 16.0, 16.0))
		_draw_brick_band(32.0, 40.0, float(world_width - 32), 144.0)
		draw_rect(Rect2(32.0, 38.0, float(world_width - 64), 4.0), Color("d1c5b5"))
		draw_line(Vector2(32.0, 614.0), Vector2(float(world_width - 32), 614.0), Color("241e23"), 5.0)
		draw_rect(Rect2(0.0, 614.0, float(world_width), 48.0), Color("b52d19"))
		for x in range(0, world_width, 14):
			var lava_points := PackedVector2Array([Vector2(float(x), 614.0), Vector2(float(x + 7), 607.0), Vector2(float(x + 14), 614.0)])
			draw_colored_polygon(lava_points, Color("ee9a27"))
		for chain_data in current_config.get("chains", []):
			_draw_chain(float(chain_data[0]), float(chain_data[1]), float(chain_data[2]))
		return
	if season == "winter":
		draw_rect(Rect2(-1000.0, 0.0, float(world_width) + 1000.0, 662.0), Color("121a22"))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2(2.0, 2.0))
		draw_texture_rect(DUNGEON_BACKGROUND, Rect2(-320.0, 0.0, float(world_width + 640) * 0.5, 331.0), true, Color("d6e8f3"))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		return
	draw_rect(Rect2(-1000.0, 0.0, float(world_width) + 1000.0, 720.0), colors["sky"])
	draw_rect(Rect2(-1000.0, 320.0, float(world_width) + 1000.0, 400.0), colors["horizon"])
	draw_circle(Vector2(float(world_width) - 185.0, 120.0), 48.0, colors["sun"])
	for index in range(int(world_width / 360.0) + 2):
		var x := float(index) * 360.0 - 90.0
		var far_points := PackedVector2Array([
			Vector2(x, 520.0), Vector2(x + 120.0, 360.0 + float(index % 3) * 28.0),
			Vector2(x + 255.0, 520.0), Vector2(x + 340.0, 405.0), Vector2(x + 420.0, 520.0)
		])
		draw_colored_polygon(far_points, colors["far"])
		var near_points := PackedVector2Array([
			Vector2(x - 60.0, 565.0), Vector2(x + 55.0, 455.0 + float(index % 2) * 24.0),
			Vector2(x + 185.0, 565.0), Vector2(x + 310.0, 455.0), Vector2(x + 470.0, 565.0)
		])
		draw_colored_polygon(near_points, colors["near"])
		if season == "winter":
			draw_circle(Vector2(x + 100.0, 470.0), 5.0, Color("ecf7fb"))
			draw_circle(Vector2(x + 330.0, 490.0), 4.0, Color("ecf7fb"))
		else:
			draw_circle(Vector2(x + 100.0, 470.0), 4.0, colors["sun"])
			draw_circle(Vector2(x + 330.0, 490.0), 4.0, colors["sun"])


func _draw_rope_line(y: float, rope_color: Color) -> void:
	for x in range(0, world_width, 20):
		draw_arc(Vector2(float(x) + 10.0, y), 8.0, 0.0, TAU, 12, rope_color, 3.0)


func _draw_log_bridge(start_x: float, end_x: float, y: float) -> void:
	draw_line(Vector2(start_x, y), Vector2(end_x, y), Color("583b35"), 8.0)
	var x := start_x
	while x <= end_x:
		draw_circle(Vector2(x, y), 8.0, Color("76452e"))
		draw_circle(Vector2(x, y - 1.0), 5.0, Color("c27b3d"))
		x += 14.0


func _draw_ladder(center_x: float, top_y: float, bottom_y: float) -> void:
	var height := bottom_y - top_y
	draw_rect(Rect2(center_x - 15.0, top_y, 7.0, height), Color("593129"))
	draw_rect(Rect2(center_x + 8.0, top_y, 7.0, height), Color("593129"))
	draw_rect(Rect2(center_x - 12.0, top_y, 3.0, height), Color("d48b45"))
	draw_rect(Rect2(center_x + 8.0, top_y, 3.0, height), Color("d48b45"))
	var rung_y := top_y + 8.0
	while rung_y < bottom_y - 5.0:
		draw_rect(Rect2(center_x - 15.0, rung_y, 30.0, 6.0), Color("593129"))
		draw_rect(Rect2(center_x - 12.0, rung_y + 1.0, 24.0, 3.0), Color("d48b45"))
		rung_y += 15.0


func _draw_chain(center_x: float, top_y: float, bottom_y: float) -> void:
	draw_line(Vector2(center_x, top_y), Vector2(center_x, bottom_y), Color("20292c"), 6.0)
	var link_y := top_y
	while link_y < bottom_y:
		draw_rect(Rect2(center_x - 3.0, link_y, 6.0, 10.0), Color("bac2b7"))
		draw_rect(Rect2(center_x - 1.0, link_y + 2.0, 2.0, 6.0), Color("38434a"))
		link_y += 11.0


func _draw_brick_band(start_x: float, top_y: float, end_x: float, bottom_y: float) -> void:
	var row := 0
	var brick_y := top_y
	while brick_y < bottom_y:
		var brick_x := start_x - (12.0 if row % 2 == 1 else 0.0)
		while brick_x < end_x:
			draw_rect(Rect2(brick_x, brick_y, 22.0, 12.0), Color("25242a"))
			draw_rect(Rect2(brick_x + 2.0, brick_y + 1.0, 18.0, 9.0), Color("908780" if row % 2 == 0 else "a49a91"))
			draw_rect(Rect2(brick_x + 3.0, brick_y + 2.0, 15.0, 2.0), Color("c7bcae"))
			draw_rect(Rect2(brick_x + 3.0, brick_y + 6.0, 15.0, 2.0), Color("746d69"))
			brick_x += 24.0
		brick_y += 14.0
		row += 1


func _palette_for_level(index: int) -> Dictionary:
	return PALETTE[str(LEVELS[index]["season"])]


func _clear_ui() -> void:
	for child in ui_root.get_children():
		child.queue_free()
	hud_level_label = null
	hud_score_label = null
	hud_lives_label = null


func _clear_world() -> void:
	if is_instance_valid(world_container):
		world_container.free()
	world_container = Node2D.new()
	world_container.name = "World"
	world_container.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(world_container)
	player = null
	current_config = {}
	world_width = 1280


func _add_overlay(alpha: float = 0.48) -> void:
	var overlay := ColorRect.new()
	overlay.color = Color(0.025, 0.055, 0.075, alpha)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_root.add_child(overlay)


func _make_panel(width: float = 560.0) -> VBoxContainer:
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ui_root.add_child(center)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(width, 0.0)
	panel.add_theme_stylebox_override("panel", _panel_style())
	center.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	panel.add_child(box)
	return box


func _panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.055, 0.105, 0.13, 0.97)
	style.border_color = Color("e8b75f")
	style.set_border_width_all(2)
	style.set_corner_radius_all(18)
	style.content_margin_left = 30.0
	style.content_margin_right = 30.0
	style.content_margin_top = 26.0
	style.content_margin_bottom = 26.0
	return style


func _make_label(text: String, size: int, color: Color = Color("f5f1dc"), centered: bool = true) -> Label:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER if centered else HORIZONTAL_ALIGNMENT_LEFT
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.55))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 2)
	return label


func _make_button(text: String, callback: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(300.0, 48.0)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", 19)
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color("276c68")
	normal.border_color = Color("70beb0")
	normal.set_border_width_all(1)
	normal.set_corner_radius_all(11)
	normal.content_margin_top = 8.0
	normal.content_margin_bottom = 8.0
	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = Color("35867d")
	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = Color("1b514f")
	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)
	button.add_theme_stylebox_override("focus", hover)
	button.pressed.connect(callback)
	return button


func _show_menu() -> void:
	state = GameState.MENU
	_clear_ui()
	_add_overlay(0.36)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ui_root.add_child(center)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(920.0, 430.0)
	var panel_style := _panel_style()
	panel_style.bg_color = Color(0.025, 0.075, 0.09, 0.96)
	panel_style.border_color = Color("72c6b1")
	panel_style.set_border_width_all(2)
	panel_style.set_corner_radius_all(20)
	panel_style.content_margin_left = 30.0
	panel_style.content_margin_right = 30.0
	panel_style.content_margin_top = 24.0
	panel_style.content_margin_bottom = 24.0
	panel.add_theme_stylebox_override("panel", panel_style)
	center.add_child(panel)
	var columns := HBoxContainer.new()
	columns.add_theme_constant_override("separation", 24)
	panel.add_child(columns)
	var intro := VBoxContainer.new()
	intro.custom_minimum_size.x = 500.0
	intro.add_theme_constant_override("separation", 12)
	columns.add_child(intro)
	intro.add_child(_make_label("UNA AVENTURA PIXEL ART", 13, Color("80d8c1"), false))
	var title := _make_label("Aventura de las\nCuatro Estaciones", 31, Color("f4c76a"), false)
	title.add_theme_constant_override("line_spacing", -2)
	intro.add_child(title)
	var description := _make_label("Recoge monedas, esquiva fantasmas y encuentra la puerta de salida.", 15, Color("d5e5dc"), false)
	description.custom_minimum_size.x = 480.0
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	intro.add_child(description)
	var season_row := HBoxContainer.new()
	season_row.add_theme_constant_override("separation", 10)
	intro.add_child(season_row)
	season_row.add_child(_make_menu_season_card("01", "PRIMAVERA", "Nivel inicial", Color("63b66d")))
	season_row.add_child(_make_menu_season_card("02", "VERANO", "Más desafíos", Color("e6a83e")))
	season_row.add_child(_make_menu_season_card("03", "FORTALEZA", "Nivel final", Color("9a92a8")))
	intro.add_child(_make_label("MOVER A / D   DOBLE SALTO: ESPACIO / W / ↑   PAUSA: ESC", 12, Color("a7c4bb"), false))
	columns.add_child(VSeparator.new())
	var form := VBoxContainer.new()
	form.custom_minimum_size.x = 330.0
	form.add_theme_constant_override("separation", 10)
	columns.add_child(form)
	form.add_child(_make_label("NUEVA PARTIDA", 22, Color("f4f1dd"), false))
	var name_caption := _make_label("Escribe tu nombre para guardar tu puntuación.", 14, Color("b8d0c7"), false)
	name_caption.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	form.add_child(name_caption)
	player_name_input = LineEdit.new()
	player_name_input.placeholder_text = "Nombre del jugador"
	player_name_input.max_length = 18
	player_name_input.custom_minimum_size = Vector2(0.0, 48.0)
	player_name_input.text = player_name
	player_name_input.alignment = HORIZONTAL_ALIGNMENT_LEFT
	player_name_input.add_theme_font_size_override("font_size", 18)
	var field_style := StyleBoxFlat.new()
	field_style.bg_color = Color("f2f0dc")
	field_style.border_color = Color("73b6a1")
	field_style.set_border_width_all(1)
	field_style.set_corner_radius_all(10)
	field_style.content_margin_left = 14.0
	field_style.content_margin_right = 14.0
	player_name_input.add_theme_stylebox_override("normal", field_style)
	player_name_input.add_theme_stylebox_override("focus", field_style)
	player_name_input.add_theme_color_override("font_color", Color("17313a"))
	form.add_child(player_name_input)
	name_hint = _make_label("", 14, Color("ff9c85"))
	name_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	form.add_child(name_hint)
	var play_button := _make_button("JUGAR", _start_new_run)
	play_button.custom_minimum_size = Vector2(0.0, 54.0)
	play_button.add_theme_font_size_override("font_size", 22)
	play_button.add_theme_color_override("font_color", Color("23343a"))
	var play_normal := StyleBoxFlat.new()
	play_normal.bg_color = Color("f2c45f")
	play_normal.border_color = Color("ffe39b")
	play_normal.set_border_width_all(2)
	play_normal.set_corner_radius_all(12)
	play_normal.content_margin_top = 10.0
	play_normal.content_margin_bottom = 10.0
	var play_hover := play_normal.duplicate() as StyleBoxFlat
	play_hover.bg_color = Color("ffda78")
	var play_pressed := play_normal.duplicate() as StyleBoxFlat
	play_pressed.bg_color = Color("dba441")
	play_button.add_theme_stylebox_override("normal", play_normal)
	play_button.add_theme_stylebox_override("hover", play_hover)
	play_button.add_theme_stylebox_override("pressed", play_pressed)
	play_button.add_theme_stylebox_override("focus", play_hover)
	form.add_child(play_button)
	var rankings_button := _make_button("VER RANKINGS", _show_rankings)
	rankings_button.custom_minimum_size = Vector2(0.0, 46.0)
	form.add_child(rankings_button)
	form.add_child(_make_label("3 niveles  |  Récords guardados en este equipo", 12, Color("9eb9b0"), false))
	player_name_input.text_submitted.connect(func(_submitted_text: String) -> void: _start_new_run())
	player_name_input.grab_focus()


func _make_menu_season_card(number: String, season_name: String, detail: String, accent: Color) -> PanelContainer:
	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.custom_minimum_size = Vector2(145.0, 86.0)
	var card_style := StyleBoxFlat.new()
	card_style.bg_color = Color(accent.r, accent.g, accent.b, 0.14)
	card_style.border_color = Color(accent.r, accent.g, accent.b, 0.72)
	card_style.set_border_width_all(1)
	card_style.set_corner_radius_all(11)
	card_style.content_margin_left = 11.0
	card_style.content_margin_right = 8.0
	card_style.content_margin_top = 8.0
	card_style.content_margin_bottom = 8.0
	card.add_theme_stylebox_override("panel", card_style)
	var details := VBoxContainer.new()
	details.add_theme_constant_override("separation", 2)
	card.add_child(details)
	details.add_child(_make_label(number, 12, accent, false))
	details.add_child(_make_label(season_name, 13, Color("f4f1dd"), false))
	details.add_child(_make_label(detail, 11, Color("b8d0c7"), false))
	return card


func _show_rankings() -> void:
	if state == GameState.MENU and is_instance_valid(player_name_input):
		player_name = player_name_input.text.strip_edges()
	state = GameState.RANKINGS
	_clear_ui()
	_add_overlay(0.64)
	var box := _make_panel(660.0)
	box.add_child(_make_label("RANKINGS", 32, Color("f4c76a")))
	box.add_child(_make_label("Mejores partidas guardadas en este dispositivo", 15, Color("c7ddd7")))
	var headings := HBoxContainer.new()
	headings.add_child(_rank_cell("#", 38.0, Color("f4c76a"), true))
	var name_heading := _rank_cell("Jugador", 0.0, Color("f4c76a"), false)
	name_heading.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	headings.add_child(name_heading)
	headings.add_child(_rank_cell("Puntos", 110.0, Color("f4c76a"), true))
	headings.add_child(_rank_cell("Nivel", 82.0, Color("f4c76a"), true))
	box.add_child(headings)
	var rankings := _load_rankings()
	if rankings.is_empty():
		box.add_child(_make_label("Todavía no hay partidas registradas. ¡Completa un nivel para aparecer aquí!", 16, Color("d5e1d9")))
	else:
		for index in range(rankings.size()):
			var entry: Dictionary = rankings[index]
			var row := HBoxContainer.new()
			row.add_child(_rank_cell(str(index + 1), 38.0, Color("f5f1dc"), true))
			var name_cell := _rank_cell(str(entry.get("name", "Jugador")), 0.0, Color("f5f1dc"), false)
			name_cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			row.add_child(name_cell)
			row.add_child(_rank_cell(str(entry.get("score", 0)), 110.0, Color("f4c76a"), true))
			var level_count := mini(int(entry.get("level", 1)), LEVELS.size())
			row.add_child(_rank_cell("%d/%d" % [level_count, LEVELS.size()], 82.0, Color("c7ddd7"), true))
			box.add_child(row)
	box.add_child(_make_button("Volver", _back_from_rankings))


func _rank_cell(text: String, width: float, color: Color, centered: bool) -> Label:
	var label := _make_label(text, 16, color, centered)
	label.custom_minimum_size.x = width
	return label


func _back_from_rankings() -> void:
	_show_menu()


func _start_new_run() -> void:
	var entered_name := player_name
	if is_instance_valid(player_name_input):
		entered_name = player_name_input.text.strip_edges()
	if entered_name.is_empty():
		if is_instance_valid(name_hint):
			name_hint.text = "Escribe un nombre para empezar."
		if is_instance_valid(player_name_input):
			player_name_input.grab_focus()
		return
	player_name = entered_name.substr(0, 18)
	lives = 3
	score = 0
	level_coins = 0
	elapsed_seconds = 0.0
	max_level_reached = 1
	run_saved = false
	_build_level(0)


func _build_level(index: int) -> void:
	if index < 0 or index >= LEVELS.size():
		return
	if is_instance_valid(world_container):
		world_container.free()
	world_container = Node2D.new()
	world_container.name = "World"
	world_container.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(world_container)
	current_level_index = index
	current_config = LEVELS[index]
	world_width = int(current_config["length"])
	platform_tile_scale = float(current_config.get("tile_scale", 3.0))
	var spawn_data: Array = current_config.get("spawn", [88, 545])
	spawn_point = Vector2(float(spawn_data[0]), float(spawn_data[1]))
	var player_scale_factor := platform_tile_scale / 3.0
	var player_half_height := 22.0 * player_scale_factor
	var spawn_surface_y := _find_spawn_surface(spawn_point.x, spawn_point.y + player_half_height)
	if spawn_surface_y >= 0.0:
		spawn_point.y = spawn_surface_y - player_half_height
	level_coins = 0
	max_level_reached = maxi(max_level_reached, index + 1)
	var palette: Dictionary = _palette_for_level(index)
	var season_atlas := load("res://assets/four_seasons/midground_/%s_.png" % str(current_config["season"])) as Texture2D
	for platform_data in current_config["ground"]:
		var ground_rows := int(platform_data[3]) if platform_data.size() > 3 else 1
		var ground_material := int(platform_data[4]) if platform_data.size() > 4 else 0
		var ground_depth := float(platform_data[5]) if platform_data.size() > 5 else -1.0
		_add_platform(int(platform_data[0]), int(platform_data[1]), int(platform_data[2]), season_atlas, ground_rows, ground_material, ground_depth)
	for platform_data in current_config["platforms"]:
		var platform_rows := int(platform_data[3]) if platform_data.size() > 3 else 1
		var platform_material := int(platform_data[4]) if platform_data.size() > 4 else 0
		_add_platform(int(platform_data[0]), int(platform_data[1]), int(platform_data[2]), season_atlas, platform_rows, platform_material)
	if str(current_config.get("season", "")) == "dungeon":
		var lava_cover := ColorRect.new()
		lava_cover.position = Vector2(0.0, 614.0)
		lava_cover.size = Vector2(float(world_width), 48.0)
		lava_cover.color = Color("b52d19")
		lava_cover.z_index = 2
		world_container.add_child(lava_cover)
	for bridge_data in current_config.get("bridges", []):
		_add_bridge(float(bridge_data[0]), float(bridge_data[1]), float(bridge_data[2]))
	for decoration in current_config.get("decorations", []):
		var decoration_scale := Vector2(platform_tile_scale, platform_tile_scale)
		if decoration.size() > 7:
			decoration_scale = Vector2(float(decoration[6]), float(decoration[7]))
		_add_decoration(float(decoration[0]), float(decoration[1]), Rect2(float(decoration[2]), float(decoration[3]), float(decoration[4]), float(decoration[5])), decoration_scale)
	for door_data in current_config.get("dungeon_doors", []):
		_add_dungeon_door(float(door_data[0]), float(door_data[1]), float(door_data[2]))
	for coin_data in current_config["coins"]:
		var coin := COIN_SCRIPT.new() as Area2D
		coin.position = Vector2(float(coin_data[0]), float(coin_data[1]))
		coin.call("setup", platform_tile_scale)
		world_container.add_child(coin)
		coin.body_entered.connect(_on_coin_body_entered.bind(coin))
	for enemy_data in current_config["enemies"]:
		var enemy := ENEMY_SCRIPT.new() as Area2D
		var enemy_x := float(enemy_data[0])
		var enemy_y := float(enemy_data[1])
		var patrol_min := float(enemy_data[2])
		var patrol_max := float(enemy_data[3])
		var support := _find_enemy_support(enemy_x, enemy_y + 12.0)
		if support.is_empty():
			continue
		enemy_y = float(support["y"]) - 13.0
		var safe_left := float(support["left"]) + 18.0
		var safe_right := float(support["right"]) - 18.0
		if safe_left > safe_right:
			safe_left = (float(support["left"]) + float(support["right"])) * 0.5
			safe_right = safe_left
		patrol_min = maxf(patrol_min, safe_left)
		patrol_max = minf(patrol_max, safe_right)
		if patrol_min > patrol_max:
			patrol_min = safe_left
			patrol_max = safe_right
		enemy_x = clampf(enemy_x, patrol_min, patrol_max)
		enemy.position = Vector2(enemy_x, enemy_y)
		var enemy_color: Color = Color(str(enemy_data[5])) if enemy_data.size() > 5 else palette["enemy"]
		enemy.call("setup", patrol_min, patrol_max, float(enemy_data[4]), enemy_color)
		world_container.add_child(enemy)
		enemy.body_entered.connect(_on_enemy_body_entered.bind(enemy))
	for hazard_data in current_config["hazards"]:
		var hazard := HAZARD_SCRIPT.new() as Area2D
		hazard.position = Vector2(float(hazard_data[0]), float(hazard_data[1]))
		hazard.call("setup", float(hazard_data[2]), palette["hazard"])
		world_container.add_child(hazard)
		hazard.body_entered.connect(_on_hazard_body_entered)
	var goal := GOAL_SCRIPT.new() as Area2D
	goal.position = Vector2(float(current_config.get("goal_x", world_width - 100)), float(current_config.get("goal_y", 555.0)))
	goal.scale = Vector2(platform_tile_scale / 3.0, platform_tile_scale / 3.0)
	goal.call("set_art_visible", bool(current_config.get("show_goal", true)))
	world_container.add_child(goal)
	goal.body_entered.connect(_on_goal_body_entered)
	player = PLAYER_SCRIPT.new()
	player.position = spawn_point
	player.scale = Vector2(platform_tile_scale / 3.0, platform_tile_scale / 3.0)
	world_container.add_child(player)
	var camera := player.get_node("Camera2D") as Camera2D
	camera.enabled = world_width > 1280
	camera.limit_left = 0 if world_width <= 1280 else -640
	camera.limit_right = world_width
	camera.limit_top = 0
	camera.limit_bottom = 662
	player.grant_invulnerability(0.6)
	state = GameState.PLAYING
	queue_redraw()
	_show_hud()


func _find_enemy_support(center_x: float, expected_surface_y: float) -> Dictionary:
	var best_support: Dictionary = {}
	var best_distance := INF
	var surfaces: Array = current_config.get("ground", []) + current_config.get("platforms", [])
	for surface_data in surfaces:
		var surface_left := float(surface_data[0])
		var surface_right := surface_left + float(surface_data[2]) * 16.0 * platform_tile_scale
		if center_x < surface_left or center_x > surface_right:
			continue
		var surface_y := float(surface_data[1])
		var distance := absf(surface_y - expected_surface_y)
		if distance < best_distance:
			best_distance = distance
			best_support = {"y": surface_y, "left": surface_left, "right": surface_right}
	return best_support


func _find_spawn_surface(center_x: float, feet_y: float) -> float:
	var best_surface_y := -1.0
	var best_distance := 32.0
	var surfaces: Array = current_config.get("ground", []) + current_config.get("platforms", [])
	for surface_data in surfaces:
		var surface_left := float(surface_data[0])
		var surface_right := surface_left + float(surface_data[2]) * 16.0 * platform_tile_scale
		if center_x < surface_left or center_x > surface_right:
			continue
		var surface_y := float(surface_data[1])
		var distance := absf(surface_y - feet_y)
		if distance < best_distance:
			best_distance = distance
			best_surface_y = surface_y
	return best_surface_y


func _add_platform(start_x: int, top_y: int, tile_count: int, atlas: Texture2D, rows: int = 1, material: int = 0, depth_override: float = -1.0) -> void:
	var tile_size := 16.0 * platform_tile_scale
	var width := float(tile_count) * tile_size
	var depth := depth_override if depth_override > 0.0 else tile_size * (float(rows) if rows > 1 else 2.0 / 3.0)
	var top_region := TILE_TOP_GRASS
	var fill_region := TILE_FILL_DIRT
	var is_dungeon := str(current_config.get("season", "")) == "dungeon"
	if is_dungeon:
		top_region = Rect2(16.0, 0.0, 16.0, 16.0)
		fill_region = Rect2(16.0, 64.0, 16.0, 16.0)
	else:
		if material == 1:
			top_region = TILE_TOP_STONE
			fill_region = TILE_FILL_STONE
		elif material == 3:
			fill_region = TILE_FILL_STONE
	var body := StaticBody2D.new()
	body.position = Vector2(float(start_x) + width * 0.5, float(top_y) + depth * 0.5)
	body.collision_layer = 1
	body.collision_mask = 1
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(width, depth)
	collision.shape = shape
	collision.one_way_collision = true
	body.add_child(collision)
	for row_index in range(rows):
		for tile_index in range(tile_count):
			var tile := Sprite2D.new()
			tile.texture = atlas
			tile.region_enabled = true
			if row_index == 0:
				tile.region_rect = top_region
			elif not is_dungeon:
				var variant_x := 64.0 + float(tile_index % 2) * 16.0
				var variant_y := (112.0 if material == 1 or material == 3 else 48.0) + float((row_index - 1) % 2) * 16.0
				tile.region_rect = Rect2(variant_x, variant_y, 16.0, 16.0)
			else:
				tile.region_rect = fill_region
			tile.scale = Vector2(platform_tile_scale, platform_tile_scale)
			tile.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			var tile_y := tile_size * 0.5 - depth * 0.5 if rows == 1 else tile_size * (float(row_index) + 0.5) - depth * 0.5
			tile.position = Vector2(-width * 0.5 + tile_size * 0.5 + float(tile_index) * tile_size, tile_y)
			body.add_child(tile)
	world_container.add_child(body)


func _add_bridge(start_x: float, end_x: float, center_y: float) -> void:
	var width := end_x - start_x
	var body := StaticBody2D.new()
	body.position = Vector2((start_x + end_x) * 0.5, center_y - 4.0)
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(width, 8.0)
	collision.shape = shape
	collision.one_way_collision = true
	body.add_child(collision)
	world_container.add_child(body)


func _add_decoration(center_x: float, ground_y: float, atlas_region: Rect2, scale_factor: Vector2) -> void:
	var decoration := Sprite2D.new()
	decoration.texture = OBJECTS_ATLAS
	decoration.region_enabled = true
	decoration.region_rect = atlas_region
	decoration.scale = scale_factor
	decoration.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	decoration.position = Vector2(center_x, ground_y - atlas_region.size.y * scale_factor.y * 0.5)
	decoration.z_index = 1
	world_container.add_child(decoration)


func _add_dungeon_door(center_x: float, ground_y: float, scale_factor: float) -> void:
	var door := Sprite2D.new()
	door.texture = DUNGEON_BACKGROUND
	door.region_enabled = true
	door.region_rect = Rect2(16.0, 72.0, 16.0, 24.0)
	door.scale = Vector2(scale_factor, scale_factor)
	door.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	door.position = Vector2(center_x, ground_y - 12.0 * scale_factor)
	door.z_index = 1
	world_container.add_child(door)


func _show_hud() -> void:
	_clear_ui()
	_build_game_hud()


func _build_game_hud() -> void:
	_build_hud_panel()


func _build_hud_panel() -> void:
	var panel := PanelContainer.new()
	panel.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	panel.offset_left = 14.0
	panel.offset_top = 8.0
	panel.offset_right = -14.0
	panel.offset_bottom = 52.0
	var style := _panel_style()
	style.bg_color = Color(0.035, 0.08, 0.1, 0.9)
	style.content_margin_left = 10.0
	style.content_margin_right = 10.0
	style.content_margin_top = 3.0
	style.content_margin_bottom = 3.0
	style.set_corner_radius_all(10)
	panel.add_theme_stylebox_override("panel", style)
	ui_root.add_child(panel)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 14)
	panel.add_child(row)
	hud_level_label = _make_label("", 15, Color("f4c76a"), false)
	hud_level_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(hud_level_label)
	row.add_child(_make_label("Jugador: %s" % player_name, 14, Color("d8e5dd"), false))
	hud_score_label = _make_label("", 14, Color("f5f1dc"), false)
	row.add_child(hud_score_label)
	hud_lives_label = _make_label("", 14, Color("f5f1dc"), false)
	row.add_child(hud_lives_label)
	var pause_button := Button.new()
	pause_button.text = "Pausa"
	pause_button.custom_minimum_size = Vector2(76.0, 30.0)
	pause_button.pressed.connect(_pause_game)
	row.add_child(pause_button)
	_update_hud()


func _update_hud() -> void:
	if is_instance_valid(hud_level_label):
		if current_level_index <= 1:
			var season_name := "PRIMAVERA" if current_level_index == 0 else "VERANO"
			hud_level_label.text = "NIVEL %d/%d · %s" % [current_level_index + 1, LEVELS.size(), season_name]
		else:
			hud_level_label.text = "NIVEL %d/%d · %s" % [current_level_index + 1, LEVELS.size(), str(current_config.get("title", ""))]
	if is_instance_valid(hud_score_label):
		hud_score_label.text = "Puntos %d  ·  Monedas %d" % [score, level_coins]
	if is_instance_valid(hud_lives_label):
		hud_lives_label.text = "Vidas %s" % "♥ ".repeat(lives)


func _pause_game() -> void:
	if state != GameState.PLAYING:
		return
	state = GameState.PAUSED
	if is_instance_valid(music_player):
		music_player.stream_paused = true
	if is_instance_valid(player):
		player.controls_enabled = false
	get_tree().paused = true
	_show_pause_screen()


func _show_pause_screen() -> void:
	_clear_ui()
	_add_overlay(0.68)
	_add_hud()
	var box := _make_panel(470.0)
	box.add_child(_make_label("PAUSA", 34, Color("f4c76a")))
	box.add_child(_make_button("Continuar", _resume_game))
	box.add_child(_make_button("Volver al inicio", _return_to_menu))


func _add_hud() -> void:
	_build_game_hud()


func _resume_game() -> void:
	if state != GameState.PAUSED:
		return
	state = GameState.PLAYING
	get_tree().paused = false
	if is_instance_valid(music_player):
		music_player.stream_paused = false
	if is_instance_valid(player):
		player.controls_enabled = true
	_show_hud()


func _on_coin_body_entered(body: Node2D, coin: Area2D) -> void:
	if state != GameState.PLAYING or body != player or not is_instance_valid(coin):
		return
	coin.queue_free()
	_play_sound(COIN_SOUND)
	level_coins += 1
	score += 50
	_update_hud()


func _on_enemy_body_entered(body: Node2D, enemy: Area2D) -> void:
	if state != GameState.PLAYING or body != player or not is_instance_valid(enemy):
		return
	if player.velocity.y > 100.0 and player.global_position.y < enemy.global_position.y - 2.0:
		enemy.queue_free()
		player.bounce()
		_play_sound(ENEMY_STOMP_SOUND)
		score += 150
		_update_hud()
	else:
		_hurt_player()


func _on_hazard_body_entered(body: Node2D) -> void:
	if state == GameState.PLAYING and body == player:
		_hurt_player()


func _on_goal_body_entered(body: Node2D) -> void:
	if state != GameState.PLAYING or body != player:
		return
	score += 250 + lives * 50
	if current_level_index == LEVELS.size() - 1:
		_finish_run(true)
	else:
		_play_sound(LEVEL_CLEAR_SOUND)
		state = GameState.LEVEL_CLEAR
		_show_level_clear()


func _play_sound(sound: AudioStream) -> void:
	if not is_instance_valid(sfx_player):
		return
	sfx_player.stream = sound
	sfx_player.play()


func _hurt_player() -> void:
	if not is_instance_valid(player) or player.invulnerability_time > 0.0:
		return
	lives -= 1
	score = maxi(0, score - 25)
	_play_sound(PLAYER_FALL_SOUND)
	if lives <= 0:
		_finish_run(false)
		return
	player.global_position = spawn_point
	player.velocity = Vector2.ZERO
	player.grant_invulnerability(1.4)
	_update_hud()


func _show_level_clear() -> void:
	_clear_ui()
	_add_overlay(0.68)
	var box := _make_panel(520.0)
	box.add_child(_make_label("¡NIVEL SUPERADO!", 30, Color("f4c76a")))
	box.add_child(_make_label(str(current_config["title"]), 19, Color("d8e5dd")))
	box.add_child(_make_label("Puntaje: %d     Monedas: %d" % [score, level_coins], 17, Color("f5f1dc")))
	box.add_child(_make_button("Siguiente nivel", _go_to_next_level))
	box.add_child(_make_button("Volver al inicio", _return_to_menu))


func _go_to_next_level() -> void:
	if state == GameState.LEVEL_CLEAR:
		_build_level(current_level_index + 1)


func _finish_run(victory: bool) -> void:
	if run_saved:
		return
	run_saved = true
	if victory:
		max_level_reached = LEVELS.size()
	_save_run_to_rankings()
	state = GameState.VICTORY if victory else GameState.GAME_OVER
	if is_instance_valid(player):
		player.controls_enabled = false
	if victory:
		_play_sound(VICTORY_SOUND)
		_show_victory_screen()
	else:
		_show_game_over_screen()


func _show_victory_screen() -> void:
	_clear_ui()
	_add_overlay(0.7)
	var box := _make_panel(540.0)
	box.add_child(_make_label("¡CAMPEÓN DE LA AVENTURA!", 29, Color("f4c76a")))
	box.add_child(_make_label("Completaste los tres niveles, %s." % player_name, 18, Color("d8e5dd")))
	box.add_child(_make_label("Puntaje: %d     Tiempo: %s" % [score, _format_time(int(elapsed_seconds))], 18, Color("f5f1dc")))
	box.add_child(_make_button("Ver rankings", _show_rankings))
	box.add_child(_make_button("Volver al inicio", _return_to_menu))


func _show_game_over_screen() -> void:
	_clear_ui()
	_add_overlay(0.72)
	var box := _make_panel(520.0)
	box.add_child(_make_label("FIN DE LA PARTIDA", 31, Color("f4c76a")))
	box.add_child(_make_label("%s llegó al nivel %d de %d." % [player_name, max_level_reached, LEVELS.size()], 18, Color("d8e5dd")))
	box.add_child(_make_label("Puntaje: %d     Tiempo: %s" % [score, _format_time(int(elapsed_seconds))], 18, Color("f5f1dc")))
	box.add_child(_make_button("Intentar de nuevo", _start_new_run))
	box.add_child(_make_button("Ver rankings", _show_rankings))
	box.add_child(_make_button("Volver al inicio", _return_to_menu))


func _return_to_menu() -> void:
	get_tree().paused = false
	if is_instance_valid(music_player):
		music_player.stream_paused = false
	_clear_world()
	queue_redraw()
	_show_menu()


func _load_rankings() -> Array:
	var path := "user://rankings.json"
	if not FileAccess.file_exists(path):
		return []
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	if parsed is Array:
		return parsed
	return []


func _save_run_to_rankings() -> void:
	var rankings := _load_rankings()
	rankings.append({
		"name": player_name,
		"score": score,
		"level": max_level_reached,
		"time": _format_time(int(elapsed_seconds))
	})
	rankings.sort_custom(func(first: Dictionary, second: Dictionary) -> bool:
		return int(first.get("score", 0)) > int(second.get("score", 0))
	)
	if rankings.size() > 10:
		rankings.resize(10)
	var file := FileAccess.open("user://rankings.json", FileAccess.WRITE)
	if file != null:
		file.store_string(JSON.stringify(rankings, "\t"))


func _format_time(total_seconds: int) -> String:
	var minutes := int(total_seconds / 60)
	var seconds := total_seconds % 60
	return "%02d:%02d" % [minutes, seconds]
