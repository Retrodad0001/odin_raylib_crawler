package crawler

import "core:fmt"
import "core:log"
import "core:strings"
import rl "vendor:raylib"

play_scene_update :: proc(game_state: ^GameState, delta_time: f32) {
	handle_input(game_state)
}

play_scene_draw :: proc(game_state: ^GameState, sprite_info: map[SpriteType]rl.Rectangle) {
	rl.ClearBackground(rl.BLACK)
	rl.DrawTextureRec(
		game_state.texture_atlas,
		sprite_info[SpriteType.knight_m_idle_anim_f0],
		game_state.player.position,
		rl.WHITE,
	)
}

play_scene_debug_draw :: proc(game_state: ^GameState) {
	fps: i32 = rl.GetFPS()
	fps_debug_text: string = fmt.tprint("FPS : ", fps)
	c_fps_debug_text: cstring = strings.clone_to_cstring(fps_debug_text, context.temp_allocator)
	rl.DrawText(c_fps_debug_text, 10, 10, 20, rl.LIME)

	player_world_position:string = fmt.tprint("Player :" , game_state.player.position)
	c_player_world_position: cstring = strings.clone_to_cstring(player_world_position, context.temp_allocator)
	rl.DrawText(c_player_world_position, 10, 30, 20, rl.LIME)
}

@(private = "file")
handle_input :: proc(game_state: ^GameState) {
	handle_input_player(game_state)
	handle_input_debug(game_state)
}

@(private = "file")
handle_input_player :: proc(game_state: ^GameState) {
	PLAYER_MAX_SPEED: f32 : 1

	if rl.IsKeyDown(rl.KeyboardKey.W) || rl.IsKeyDown(rl.KeyboardKey.UP) {
		game_state.player.position.y -= PLAYER_MAX_SPEED //yes i know .. could be done better than this
	}
	if rl.IsKeyDown(rl.KeyboardKey.S) || rl.IsKeyDown(rl.KeyboardKey.DOWN) {
		game_state.player.position.y += PLAYER_MAX_SPEED //yes i know .. could be done better than this
	}
	if rl.IsKeyDown(rl.KeyboardKey.D) || rl.IsKeyDown(rl.KeyboardKey.RIGHT) {
		game_state.player.position.x += PLAYER_MAX_SPEED //yes i know .. could be done better than this
	}
	if rl.IsKeyDown(rl.KeyboardKey.A) || rl.IsKeyDown(rl.KeyboardKey.LEFT) {
		game_state.player.position.x -= PLAYER_MAX_SPEED //yes i know .. could be done better than this
	}
}

@(private = "file")
handle_input_debug :: proc(game_state: ^GameState) {
	if rl.IsKeyDown(rl.KeyboardKey.F1) {
		game_state.show_debug = !game_state.show_debug
	}
}