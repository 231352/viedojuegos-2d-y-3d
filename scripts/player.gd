extends CharacterBody2D

var move_speed := 330.0
var jump_speed := -570.0
var gravity := 1450.0
var controls_enabled := true
var invulnerability_time := 0.0
var facing := 1
var air_jumps_left := 1
var jump_buffer_time := 0.0
var w_key_was_down := false
var space_key_was_down := false
var jump_was_held := false

const JUMP_BUFFER_DURATION := 0.12


func _ready() -> void:
	z_index = 5
	collision_layer = 1
	collision_mask = 1
	floor_snap_length = 4.0
	floor_max_angle = 0.9
	var hitbox := CollisionShape2D.new()
	var capsule := CapsuleShape2D.new()
	capsule.radius = 12.0
	# Match the drawn boots so the character's feet meet the platform surface.
	capsule.height = 44.0
	hitbox.shape = capsule
	add_child(hitbox)
	var camera := Camera2D.new()
	camera.name = "Camera2D"
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 7.0
	camera.limit_top = 0
	camera.limit_bottom = 662
	add_child(camera)


func _physics_process(delta: float) -> void:
	if invulnerability_time > 0.0:
		invulnerability_time = maxf(0.0, invulnerability_time - delta)
		queue_redraw()
	if not controls_enabled:
		velocity = Vector2.ZERO
		return

	var direction := Input.get_axis("ui_left", "ui_right")
	if Input.is_key_pressed(KEY_A):
		direction = -1.0
	elif Input.is_key_pressed(KEY_D):
		direction = 1.0
	if direction != 0.0:
		facing = int(signf(direction))
	velocity.x = direction * move_speed
	if is_on_floor():
		air_jumps_left = 1
	if not is_on_floor():
		velocity.y += gravity * delta
	elif velocity.y > 0.0:
		velocity.y = 0.0

	var jump_pressed := Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up")
	var space_is_down := Input.is_key_pressed(KEY_SPACE)
	var w_is_down := Input.is_key_pressed(KEY_W)
	if (space_is_down and not space_key_was_down) or (w_is_down and not w_key_was_down):
		jump_pressed = true
	space_key_was_down = space_is_down
	w_key_was_down = w_is_down
	if jump_pressed:
		jump_buffer_time = JUMP_BUFFER_DURATION
	else:
		jump_buffer_time = maxf(0.0, jump_buffer_time - delta)
	var jump_is_held := Input.is_action_pressed("ui_accept") or Input.is_action_pressed("ui_up") or space_is_down or w_is_down
	if jump_buffer_time > 0.0:
		if is_on_floor():
			velocity.y = jump_speed
			jump_buffer_time = 0.0
		elif air_jumps_left > 0:
			air_jumps_left -= 1
			velocity.y = jump_speed * 0.92
			jump_buffer_time = 0.0
	if jump_was_held and not jump_is_held and velocity.y < 0.0:
		# Releasing jump early gives a shorter hop, like a classic arcade platformer.
		velocity.y *= 0.55
	jump_was_held = jump_is_held
	move_and_slide()


func grant_invulnerability(seconds: float) -> void:
	invulnerability_time = seconds
	air_jumps_left = 1
	jump_buffer_time = 0.0
	jump_was_held = false
	queue_redraw()


func bounce() -> void:
	velocity.y = jump_speed * 0.62
	air_jumps_left = 1


func _draw() -> void:
	var flash := invulnerability_time > 0.0 and int(Time.get_ticks_msec() / 90) % 2 == 0
	if flash:
		return
	var step := 0.0
	if absf(velocity.x) > 20.0:
		step = sin(Time.get_ticks_msec() * 0.02) * 2.0
	# Dark pixel outline and layered colors keep the hero readable on the tiles.
	draw_rect(Rect2(-12.0, -24.0, 24.0, 21.0), Color("17252d"))
	draw_rect(Rect2(-9.0, -21.0, 18.0, 15.0), Color("f2c79c"))
	draw_rect(Rect2(-11.0, -24.0, 22.0, 6.0), Color("263b46"))
	draw_rect(Rect2(-10.0, -18.0, 6.0, 5.0), Color("263b46"))
	var eye_x := 3.0 if facing > 0 else -6.0
	draw_rect(Rect2(eye_x, -15.0, 3.0, 3.0), Color("17252d"))
	draw_rect(Rect2(-13.0, -6.0, 26.0, 26.0), Color("17252d"))
	draw_rect(Rect2(-10.0, -4.0, 20.0, 22.0), Color("277d79"))
	draw_rect(Rect2(-7.0, -3.0, 5.0, 13.0), Color("42a092"))
	draw_rect(Rect2(-11.0, 1.0, 22.0, 5.0), Color("edb84d"))
	draw_rect(Rect2(-10.0, 12.0 + step, 8.0, 7.0), Color("263b46"))
	draw_rect(Rect2(2.0, 12.0 - step, 8.0, 7.0), Color("263b46"))
	draw_rect(Rect2(-12.0, 18.0 + step, 11.0, 4.0), Color("16252d"))
	draw_rect(Rect2(1.0, 18.0 - step, 11.0, 4.0), Color("16252d"))
