package crawler

import "core:log"

import rl "vendor:raylib"

play_scene_update :: proc(general_game_state: ^GeneralGameState, delta_time: f32) {

}

play_scene_draw :: proc(
	general_game_state: ^GeneralGameState,
	sprite_info: map[SpriteType]rl.Rectangle,
) {

	rl.ClearBackground(rl.BLACK)
	rl.DrawTextureRec(
		general_game_state.texture_atlas,
		sprite_info[SpriteType.PLAYER_IDLE_1],
		100.100,
		rl.WHITE,
	)

	rl.DrawText("here the hud", 10, 10, 20, rl.GRAY)
}
