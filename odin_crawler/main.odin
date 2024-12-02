package crawler

import "base:runtime"

import "core:c"
import "core:log"

import rl "vendor:raylib"
import stbsp "vendor:stb/sprintf"

g_ctx: runtime.Context

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


	when ODIN_DEBUG {
		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)

		defer {
			if len(track.allocation_map) > 0 {
				fmt.eprintf("=== %v allocations not freed: ===\n", len(track.allocation_map))
				for _, entry in track.allocation_map {
					fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			if len(track.bad_free_array) > 0 {
				fmt.eprintf("=== %v incorrect frees: ===\n", len(track.bad_free_array))
				for entry in track.bad_free_array {
					fmt.eprintf("- %p @ %v\n", entry.memory, entry.location)
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

	for !rl.WindowShouldClose() {

		rl.BeginDrawing()

		rl.ClearBackground(rl.BLACK)

		rl.DrawText("here comes the hud", 10, 10, 20, rl.GRAY)

		rl.EndDrawing()

		free_all(context.temp_allocator)
	}
}
