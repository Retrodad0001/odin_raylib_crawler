package crawler

import rl "vendor:raylib"

game_over_scene_update :: proc() {

}

game_over_scene_draw :: proc() {

	rl.ClearBackground(rl.BLACK)

	rl.DrawText("GAME OVER", 10, 10, 50, rl.GRAY)
}
