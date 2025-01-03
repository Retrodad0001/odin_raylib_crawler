package crawler

import "core:log"
import rl "vendor:raylib"

game_over_scene_update :: proc(game_state: ^GameState, delta_time: f32) {

}

game_over_scene_draw :: proc(game_state: ^GameState) {
	rl.ClearBackground(rl.BLACK)
	rl.DrawText("GAME OVER", 10, 10, 20, rl.GRAY)
}
