TitleMenu = new Menu
TitleMenu.options = [ "Start game", "How to play", "About" ]

// @returns {TitleMenu}
TitleMenu.make = function
    self.selected = 0
end function

TitleMenu.tick = function
    if self.input.up.clicked then self.selected -= 1
    if self.input.down.clicked then self.selected += 1

    len = self.options.len
    if self.selected < 0 then self.selected += len
    if self.selected >= len then self.selected -= len

    if self.input.attack.clicked or input.menu.clicked then
        if selected == 0 then
            Sound.test.play
            self.game.resetGame
            self.game.setMenu
        end if
        if self.selected == 1 then self.game.setMenu((new InstructionsMenu).make(self))
        if self.selected == 2 then self.game.setMenu((new AboutMenu).make(self))
    end if
end function

// @param {Screen} screen
TitleMenu.render = function
    screen.clear(0)

    h = 2
    w = 13
    titleColor = Color.get(0, 010, 131, 551)
    xo = (screen.w - w * 8) / 2
    yo = 24
    for y in range(0, h - 1)
        for x in range(0, w - 1)
            screen.render(xo + x * 8, yo + y * 8, x + (y + 6) * 32, titleColor, 0)
        end for
    end for

    for i in range(0, 3 - 1)
        msg = self.options[i]
        self.col = Color.get(0, 222, 222, 222)
        if i == self.selected then
            msg = "> " + msg + " <"
            col = Color.get(0, 555, 555, 555)
        end if
        Font.draw(msg, screen, (screen.w - msg.length() * 8) / 2, (8 + i) * 8, col)
    end for

    Font.draw("(Arrow keys,X and C)", screen, 0, screen.h - 8, Color.get(0, 111, 111, 111))
end function

return TitleMenu
