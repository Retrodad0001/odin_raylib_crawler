package crawler

import rl "vendor:raylib"

play_scene_update :: proc() {

}

play_scene_draw :: proc() {
	rl.ClearBackground(rl.BLACK)

	rl.DrawText("here the hud", 10, 10, 20, rl.GRAY)
}
