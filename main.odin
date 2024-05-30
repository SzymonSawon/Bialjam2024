package truck

import "core:fmt"
import rl "vendor:raylib"

WIDTH :: 1600
HEIGHT :: 900
BACKGROUND :: rl.Color{0x18, 0x18, 0x18, 0xff}

main :: proc() {
	rl.InitWindow(WIDTH, HEIGHT, "InterdimensionalFoodTruck")
	defer rl.CloseWindow()

	rl.SetTargetFPS(120)
	rl.DisableCursor()

	world := World{}
	init_world(&world)

	fmt.printfln("%f", world)


	for !rl.WindowShouldClose() {
		dt := rl.GetFrameTime()
		update_world(&world, dt)

		rl.BeginDrawing()
		defer rl.EndDrawing()

		{
			rl.BeginMode3D(world.main_camera)
			defer rl.EndMode3D()

			rl.ClearBackground(BACKGROUND)
			rl.DrawGrid(10, 1)

			draw_world(&world, dt)
		}
		when ODIN_DEBUG {
			rl.DrawFPS(10, 10)
		}
	}
}
