package truck

import "core:fmt"
import rl "vendor:raylib"

WIDTH :: 1600
HEIGHT :: 900
BACKGROUND :: rl.Color{0x18, 0x18, 0x18, 0xff}
PIXELIZE :: 4

main :: proc() {
	rl.InitWindow(WIDTH, HEIGHT, "InterdimensionalFoodTruck")
	defer rl.CloseWindow()

	rl.SetTargetFPS(120)
	rl.DisableCursor()

	world := World{}
	init_world(&world)
	defer deinit_world(&world)

	for !rl.WindowShouldClose() {
		dt := rl.GetFrameTime()
		update_world(&world, dt)

		rl.BeginDrawing()
		defer rl.EndDrawing()

		update_render_textures(&world)

		{
			rl.BeginTextureMode(world.world_layer)
			defer rl.EndTextureMode()
			draw_world(&world, dt)
		}
		{
			rl.BeginTextureMode(world.hud_layer)
			defer rl.EndTextureMode()
			draw_3d_hud(&world, dt)
		}

		{
			rl.BeginShaderMode(world.assets.postprocess_shader)
			defer rl.EndShaderMode()
			rl.DrawTextureEx(world.world_layer.texture, {0, 0}, 0, PIXELIZE, rl.WHITE)
			rl.DrawTextureEx(world.hud_layer.texture, {0, 0}, 0, PIXELIZE, rl.WHITE)
		}

		when ODIN_DEBUG {
			rl.DrawFPS(10, 10)
		}
	}
}
