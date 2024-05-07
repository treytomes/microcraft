LevelTransitionMenu = new Menu

// @param {int} dir
// @returns {LevelTransitionMenu}
LevelTransitionMenu.make = function(dir)
    super.make
    self.time = 0
    self.dir = dir
    return self
end function

LevelTransitionMenu.tick = function()
    self.time += 2
    if self.time == 30 then self.game.changeLevel(self.dir)
    if self.time == 60 then self.game.setMenu(null)
end function

// @param {Screen} screen
LevelTransitionMenu.render = function(screen)
    for x in range(0, 20 - 1)
        for y in range(0, 15 - 1)
            dd = (y + x % 2 * 2 + x / 3) - self.time
            if dd < 0 and dd > -30 then
                if self.dir > 0 then
                    screen.render(x * 8, y * 8, 0, 0, 0)
                else
                    screen.render(x * 8, screen.h - y * 8 - 8, 0, 0, 0)
                end if
            end if
        end for
    end for
end function

return LevelTransitionMenu
