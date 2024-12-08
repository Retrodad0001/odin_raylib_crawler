package crawler

import "base:runtime"

import "core:c"
import "core:log"
import "core:mem"

import rl "vendor:raylib"
import stbsp "vendor:stb/sprintf"

g_ctx: runtime.Context

SceneState :: enum {
	menu,
	playing,
	game_over,
}

GameState :: struct {
	current_scene_state: SceneState,
}


main :: proc() {
	context.logger = log.create_console_logger(.Debug)
	g_ctx = context

	rl.SetTraceLogLevel(.ALL)
	rl.SetTraceLogCallback(
		proc "c" (rl_level: rl.TraceLogLevel, message: cstring, args: ^c.va_list) {
			context = g_ctx

			level: log.Level
			switch rl_level {
			case .TRACE, .DEBUG:
				level = .Debug
			case .INFO:
				level = .Info
			case .WARNING:
				level = .Warning
			case .ERROR:
				level = .Error
			case .FATAL:
				level = .Fatal
			case .ALL, .NONE:
				fallthrough
			case:
				log.panicf("unexpected log level %v", rl_level)
			}

			@(static) buf: [dynamic]byte
			log_len: i32
			for {
				buf_len := i32(len(buf))
				log_len = stbsp.vsnprintf(raw_data(buf), buf_len, message, args)
				if log_len <= buf_len {
					break
				}

				non_zero_resize(&buf, max(128, len(buf) * 2))
			}

			context.logger.procedure(
				context.logger.data,
				level,
				string(buf[:log_len]),
				context.logger.options,
			)
		},
	)

	if ODIN_DEBUG {
		log.debug("-- Memory detection is online! --")

		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)

		defer {
			if len(track.allocation_map) > 0 {
				log.warnf("=== %v allocations not freed: ===\n", len(track.allocation_map))
				for _, entry in track.allocation_map {
					log.warnf("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			if len(track.bad_free_array) > 0 {
				log.warnf("=== %v incorrect frees: ===\n", len(track.bad_free_array))
				for entry in track.bad_free_array {
					log.warnf("- %p @ %v\n", entry.memory, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track)
		}
	}

	SCREEN_WIDTH :: i32(1920)
	SCREEN_HEIGHT :: i32(1080)

	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "raylib Odin crawler demo")
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)

	//setup initial game state 
	game_state: GameState = {
		current_scene_state = SceneState.menu,
	}


	delta_time: f32 = rl.GetFrameTime()

	for !rl.WindowShouldClose() {

		delta_time: f32 = rl.GetFrameTime()

		rl.BeginDrawing()

		switch game_state.current_scene_state {
		case .menu:
			menu_scene_update()
			menu_scene_draw()
		case .playing:
			play_scene_update()
			play_scene_draw()
		case .game_over:
			game_over_scene_update()
			game_over_scene_draw()
		}

		rl.EndDrawing()

		free_all(context.temp_allocator)
	}
}
