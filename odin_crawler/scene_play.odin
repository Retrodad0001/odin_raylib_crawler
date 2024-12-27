package crawler

import "core:log"
import rl "vendor:raylib"

play_scene_update :: proc(game_state: ^GameState, delta_time: f32) {
	handle_input(game_state)
}

play_scene_draw :: proc(game_state: ^GameState, sprite_info: map[SpriteType]rl.Rectangle) {

	rl.ClearBackground(rl.BLACK)
	rl.DrawTextureRec(
		game_state.texture_atlas,
		sprite_info[SpriteType.PLAYER_IDLE_1],
		game_state.player.position,
		rl.WHITE,
	)

	rl.DrawText("here comes the hud soon", 10, 10, 10, rl.GRAY)
}

handle_input :: proc(game_state: ^GameState) {

	PLAYER_MAX_SPEED: f32  : 1

	if rl.IsKeyDown(rl.KeyboardKey.W) || rl.IsKeyDown(rl.KeyboardKey.UP){
		game_state.player.position.y -= PLAYER_MAX_SPEED //yes i know .. could be done better than this
	}
	if rl.IsKeyDown(rl.KeyboardKey.S) || rl.IsKeyDown(rl.KeyboardKey.DOWN){
		game_state.player.position.y += PLAYER_MAX_SPEED //yes i know .. could be done better than this
	}
	if rl.IsKeyDown(rl.KeyboardKey.D) || rl.IsKeyDown(rl.KeyboardKey.RIGHT){
		game_state.player.position.x += PLAYER_MAX_SPEED //yes i know .. could be done better than this
	}
	if rl.IsKeyDown(rl.KeyboardKey.A) || rl.IsKeyDown(rl.KeyboardKey.LEFT){
		game_state.player.position.x -= PLAYER_MAX_SPEED //yes i know .. could be done better than this
	}
}
