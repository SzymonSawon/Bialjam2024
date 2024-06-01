package truck

import "core:fmt"
import rl "vendor:raylib"

WIDTH :: 1600
HEIGHT :: 900
BACKGROUND :: rl.Color{0x18, 0x18, 0x18, 0xff}
PIXELIZE :: 4

main :: proc() {
    rl.SetConfigFlags({.WINDOW_RESIZABLE})
	rl.InitWindow(WIDTH, HEIGHT, "InterdimensionalFoodTruck")
	defer rl.CloseWindow()

	rl.InitAudioDevice()
	defer rl.CloseAudioDevice()

    rl.SetExitKey(nil)

	rl.SetTargetFPS(120)

	world := World{}
	init_world(&world)
	defer deinit_world(&world)

	for !rl.WindowShouldClose() && !world.should_quit {
		if rl.IsKeyPressed(.F11) {
			rl.ToggleFullscreen()
		}
        if rl.IsKeyPressed(.F6) && rl.IsKeyDown(.LEFT_CONTROL) {
            world_reload(&world);
        }
		dt := rl.GetFrameTime()

        when ODIN_DEBUG {
            if rl.IsKeyDown(.F) {
                dt *= 10
            }
        }

        if(world.sk == .GAMEPLAY) {
            update_world(&world, dt)
        }

		rl.BeginDrawing()
		defer rl.EndDrawing()

		update_render_textures(&world)

		{
			rl.BeginTextureMode(world.recipe_layer)
			defer rl.EndTextureMode()
			draw_recipe_layer(&world)
		}
		{
			rl.BeginTextureMode(world.world_layer)
			defer rl.EndTextureMode()
			draw_world(&world, dt)
		}

		{
			rl.BeginShaderMode(world.assets.postprocess_shader)
			defer rl.EndShaderMode()
			rl.DrawTextureEx(world.world_layer.texture, {0, 0}, 0, PIXELIZE, rl.WHITE)
		}

		switch world.sk {
        case .GAMEPLAY:
            {
                rl.BeginTextureMode(world.hud_layer)
                defer rl.EndTextureMode()
                draw_3d_hud(&world, dt)
            }
            {
                rl.BeginShaderMode(world.assets.postprocess_shader)
                defer rl.EndShaderMode()
                rl.DrawTextureEx(world.hud_layer.texture, {0, 0}, 0, PIXELIZE, rl.WHITE)
            }
        case .INTRO:
			intro_scene(&world, dt)
        case .MENU:
			menu_scene(&world)
        case .GAME_OVER:
			game_over_scene(&world)
		}


		when ODIN_DEBUG {
			rl.DrawFPS(10, 10)
		}
	}

    rl.EnableCursor()
}
