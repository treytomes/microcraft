Game = {}
Game.NAME = "Minicraft"
Game.HEIGHT = 120
Game.WIDTH = 160
// Game.SCALE = 3
Game.SCALE = 5.3
Game.IMAGE = file.loadImage("assets/icons.png")

Game.make = function
    self.pixels = [0] * Game.WIDTH * Game.HEIGHT
    self.running = false
    self.screen = null
    self.lightScreen = null
    self.guiScreen = null
    self.input = (new InputHandler).make

    self.tickCount = 0
    self.gameTime = 0

    self.level = null
    self.levels = [null, null, null, null, null]
    self.currentLevel = 3
    self.player = null

    self.menu = null
    self.playerDeadTime = 0
    self.pendingLevelChange = 0
    self.wonTimer = 0
    self.hasWon = false

    return self
end function

// @param {Menu} menu
Game.setMenu = function(menu)
    self.menu = menu
    if self.menu != null then self.menu.init(self, self.input)
end function

Game.start = function
    self.running = true
    // self.run
end function

Game.stop = function
    self.running = false
end function

Game.getColors = function
    colors = [0] * 256

    pp = 0
    for r in range(0, 5)
        for g in range(0, 5)
            for b in range(0, 5)
                rr = floor(r * 255 / 5)
                gg = floor(g * 255 / 5)
                bb = floor(b * 255 / 5)
                mid = floor((rr * 30 + gg * 59 + bb * 11) / 100)

                r1 = floor(((rr + mid * 1) / 2) * 230 / 255 + 10)
                g1 = floor(((gg + mid * 1) / 2) * 230 / 255 + 10)
                b1 = floor(((bb + mid * 1) / 2) * 230 / 255 + 10)

                // colors[pp] = bitOr(bitOr((r1 * 65536), g1 * 256), b1)
                colors[pp] = color.fromList([r1, g1, b1])
                pp += 1
            end for
        end for
    end for

    return colors
end function
Game.COLORS = Game.getColors

Game.resetGame = function
    self.playerDeadTime = 0
    self.wonTimer = 0
    self.gameTime = 0
    self.hasWon = false

    self.levels = [null] * 5
    self.currentLevel = 3

    // TODO: Make sure you get a new game on a real in-game reset.
    if not self.menu isa TitleMenu then
        print "Generating levels..."
        self.levels[4] = (new Level).make(128, 128, 1, null)
        print "Level 4 done."
        self.levels[3] = (new Level).make(128, 128, 0, self.levels[4])
        print "Level 3 done."
        self.levels[2] = (new Level).make(128, 128, -1, self.levels[3])
        print "Level 2 done."
        self.levels[1] = (new Level).make(128, 128, -2, self.levels[2])
        print "Level 1 done."
        self.levels[0] = (new Level).make(128, 128, -3, self.levels[1])
        print "Level 0 done.  All done."

        self.level = self.levels[self.currentLevel]
        self.player = (new Player).make(self, self.input)
        self.player.findStartPos(self.level)

        self.level.add(self.player)

        print "Spawning entities."
        for i in range(0, 5 - 1)
            // self.levels[i].trySpawn(5000, i)

            // 5000 was taking too long.
            self.levels[i].trySpawn(20) //, i)
        end for
        print "Done spawning entities."
    end if

    text.clear
    // gfx.clear
end function

Game.init = function
    self.screen = (new Screen).make(Game.WIDTH, Game.HEIGHT, (new SpriteSheet).make(Game.IMAGE))
    self.screen.install 6
    
    self.lightScreen = (new Screen).make(Game.WIDTH, Game.HEIGHT, (new SpriteSheet).make(Game.IMAGE))

    self.guiScreen = (new Screen).make(Game.WIDTH, Game.HEIGHT, (new SpriteSheet).make(Game.IMAGE))
    self.guiScreen.install 5

    // This is causing the levels array to be generated on load *and* on start game.
    self.resetGame()

    self.setMenu((new TitleMenu).make)
end function

// Game.run = function
//     long lastTime = System.nanoTime();
//     double unprocessed = 0;
//     double nsPerTick = 1000000000.0 / 60;
//     int frames = 0;
//     int ticks = 0;
//     long lastTimer1 = System.currentTimeMillis();

//     init();

//     while (running) {
//         long now = System.nanoTime();
//         unprocessed += (now - lastTime) / nsPerTick;
//         lastTime = now;
//         boolean shouldRender = true;
//         while (unprocessed >= 1) {
//             ticks++;
//             tick();
//             unprocessed -= 1;
//             shouldRender = true;
//         }

//         try {
//             Thread.sleep(2);
//         } catch (InterruptedException e) {
//             e.printStackTrace();
//         }

//         if (shouldRender) {
//             frames++;
//             render();
//         }

//         if (System.currentTimeMillis() - lastTimer1 > 1000) {
//             lastTimer1 += 1000;
//             System.out.println(ticks + " ticks, " + frames + " fps");
//             frames = 0;
//             ticks = 0;
//         }
//     }
// end function

Game.tick = function
    self.tickCount += 1

    // TODO: Ignoring this bit, as the Mini Micro has no focus indicator.
    // if (!hasFocus()) {
    //     input.releaseAll();
    // } else {
        if not self.player.removed and not self.hasWon then self.gameTime += 1

        self.input.tick
        if self.menu != null then
            self.menu.tick
        else
            if self.player.removed then
                self.playerDeadTime += 1
                if self.playerDeadTime > 60 then
                    self.setMenu((new DeadMenu).make)
                end if
            else
                if self.pendingLevelChange != 0 then
                    setMenu((new LevelTransitionMenu).make(self.pendingLevelChange))
                    self.pendingLevelChange = 0
                end if
            end if
            if self.wonTimer > 0 then
                self.wonTimer -= 1
                if self.wonTimer == 0 then
                    self.setMenu (new WonMenu).make
                end if
            end if
            self.level.tick
            Tile.tickCount += 1
        end if
    // }
end function

Game.changeLevel = function(dir)
    self.level.remove(self.player);
    self.currentLevel += dir
    self.level = self.levels[self.currentLevel]
    self.player.x = floor(player.x / 16) * 16 + 8
    self.player.y = floor(player.y / 16) * 16 + 8
    self.level.add(player)
end function

Game.render = function
    // BufferStrategy bs = getBufferStrategy();
    // if (bs == null) {
    //     createBufferStrategy(3);
    //     requestFocus();
    //     return;
    // }

    xScroll = self.player.x - floor(self.screen.w / 2)
    yScroll = self.player.y - floor((self.screen.h - 8) / 2)
    if xScroll < 16 then xScroll = 16
    if yScroll < 16 then yScroll = 16
    if xScroll > self.level.w * 16 - self.screen.w - 16 then xScroll = self.level.w * 16 - self.screen.w - 16
    if yScroll > self.level.h * 16 - self.screen.h - 16 then yScroll = self.level.h * 16 - self.screen.h - 16
    if self.currentLevel > 3 then
        col = Color.get(20, 20, 121, 121)
        for y in range(0, 14 - 1)
            for x in range(0, 24 - 1)
                self.screen.render(x * 8 - bitAnd(floor(xScroll / 4), 7), y * 8 - bitAnd(floor(yScroll / 4), 7), 0, col, 0)
            end for
        end for
    end if

    self.level.renderBackground(self.screen, xScroll, yScroll)
    self.level.renderSprites(self.screen, xScroll, yScroll)

    if self.currentLevel < 3 then
        self.lightScreen.clear(0)
        self.level.renderLight(self.lightScreen, xScroll, yScroll)
        self.screen.overlay(self.lightScreen, xScroll, yScroll)
    end if

    self.renderGui

    // TODO: I don't think the Mini Micro knows if it has focus.
    // if (!hasFocus()) renderFocusNagger()

    // for y in range(0, self.screen.h - 1)
    //     for x in range(0, self.screen.w - 1)
    //         cc = self.screen.pixels[x + y * self.screen.w]

    //         // Immediately draw to the PixelDisplay.
    //         // TODO: I'm ignoring the *3 scale for the moment.
    //         if cc < 255 then
    //             gfx.setPixel x, self.screen.h - y - 1, Game.COLORS[cc]
    //         else
    //             // TODO: This bit might not be needed.
    //             // gfx.setPixel x, self.screen.h - y - 1, color.red
    //             // gfx.setPixel x, self.screen.h - y - 1, color.black
    //         end if
    //     end for
    // end for

    self.screen.flip
    self.guiScreen.flip

    // img = self.screen.display.getImage
    // img.flip true
    // gfx.drawImage img
end function

Game.renderGui = function
    self.guiScreen.clear -1

    for y in range(0, 2 - 1)
        for x in range(0, 20 - 1)
            self.guiScreen.render(x * 8, self.guiScreen.h - 16 + y * 8, 0 + 12 * 32, Color.get(000, 000, 000, 000), 0)
        end for
    end for

    for i in range(0, 10 - 1)
        if i < self.player.health then
            self.guiScreen.render(i * 8, self.guiScreen.h - 16, 0 + 12 * 32, Color.get(000, 200, 500, 533), 0)
        else
            self.guiScreen.render(i * 8, self.guiScreen.h - 16, 0 + 12 * 32, Color.get(000, 100, 000, 000), 0)
        end if

        if self.player.staminaRechargeDelay > 0 then
            if floor(plaself.playeryer.staminaRechargeDelay / 4) % 2 == 0 then
                self.guiScreen.render(i * 8, self.guiScreen.h - 8, 1 + 12 * 32, Color.get(000, 555, 000, 000), 0)
            else
                self.guiScreen.render(i * 8, self.guiScreen.h - 8, 1 + 12 * 32, Color.get(000, 110, 000, 000), 0)
            end if
        else
            if i < self.player.stamina then
                self.guiScreen.render(i * 8, self.guiScreen.h - 8, 1 + 12 * 32, Color.get(000, 220, 550, 553), 0)
            else
                self.guiScreen.render(i * 8, self.guiScreen.h - 8, 1 + 12 * 32, Color.get(000, 110, 000, 000), 0)
            end if
        end if
    end for
    if self.player.activeItem != null then
        self.player.activeItem.renderInventory(self.guiScreen, 10 * 8, self.guiScreen.h - 16)
    end if

    if self.menu != null then
        self.menu.render(self.guiScreen)
    end if
end function

Game.renderFocusNagger = function
    msg = "Click to focus!"
    xx = floor((WIDTH - msg.len * 8) / 2)
    yy = floor((HEIGHT - 8) / 2)
    w = msg.len
    h = 1

    screen.render(xx - 8, yy - 8, 0 + 13 * 32, Color.get(-1, 1, 5, 445), 0)
    screen.render(xx + w * 8, yy - 8, 0 + 13 * 32, Color.get(-1, 1, 5, 445), 1)
    screen.render(xx - 8, yy + 8, 0 + 13 * 32, Color.get(-1, 1, 5, 445), 2)
    screen.render(xx + w * 8, yy + 8, 0 + 13 * 32, Color.get(-1, 1, 5, 445), 3)
    for x in range(0, w - 1)
        screen.render(xx + x * 8, yy - 8, 1 + 13 * 32, Color.get(-1, 1, 5, 445), 0)
        screen.render(xx + x * 8, yy + 8, 1 + 13 * 32, Color.get(-1, 1, 5, 445), 2)
    end for
    for y in range(0, h - 1)
        screen.render(xx - 8, yy + y * 8, 2 + 13 * 32, Color.get(-1, 1, 5, 445), 0)
        screen.render(xx + w * 8, yy + y * 8, 2 + 13 * 32, Color.get(-1, 1, 5, 445), 1)
    end for

    if floor(self.tickCount / 20) % 2 == 0 then
        Font.draw(msg, screen, xx, yy, Color.get(5, 333, 333, 333))
    else
        Font.draw(msg, screen, xx, yy, Color.get(5, 555, 555, 555))
    end if
end function

Game.scheduleLevelChange = function(dir)
    self.pendingLevelChange = dir
end function

Game.won = function
    self.wonTimer = 60 * 3
    self.hasWon = true
end function

// public static void main(String[] args) {
//     Game game = new Game();
//     game.setMinimumSize(new Dimension(WIDTH * SCALE, HEIGHT * SCALE));
//     game.setMaximumSize(new Dimension(WIDTH * SCALE, HEIGHT * SCALE));
//     game.setPreferredSize(new Dimension(WIDTH * SCALE, HEIGHT * SCALE));

//     JFrame frame = new JFrame(Game.NAME);
//     frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
//     frame.setLayout(new BorderLayout());
//     frame.add(game, BorderLayout.CENTER);
//     frame.pack();
//     frame.setResizable(false);
//     frame.setLocationRelativeTo(null);
//     frame.setVisible(true);

//     game.start();
// }

return Game
