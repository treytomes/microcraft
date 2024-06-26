AboutMenu = new Menu

// @param {Menu} parent
// @returns {AboutMenu}
AboutMenu.make = function(parent)
    super.make
    self.parent = parent
    return self
end function

AboutMenu.tick = function
    if self.input.attack.clicked or self.input.menu.clicked then
        self.game.setMenu(self.parent)
    end if
end function

// @param {Screen} screen
AboutMenu.render = function(screen)
    screen.clear(0)

    Font.draw("About Minicraft", screen, 2 * 8 + 4, 1 * 8, Color.get(0, 555, 555, 555))
    Font.draw("Minicraft was made", screen, 0 * 8 + 4, 3 * 8, Color.get(0, 333, 333, 333))
    Font.draw("by Markus Persson", screen, 0 * 8 + 4, 4 * 8, Color.get(0, 333, 333, 333))
    Font.draw("For the 22'nd ludum", screen, 0 * 8 + 4, 5 * 8, Color.get(0, 333, 333, 333))
    Font.draw("dare competition in", screen, 0 * 8 + 4, 6 * 8, Color.get(0, 333, 333, 333))
    Font.draw("december 2011.", screen, 0 * 8 + 4, 7 * 8, Color.get(0, 333, 333, 333))
    Font.draw("it is dedicated to", screen, 0 * 8 + 4, 9 * 8, Color.get(0, 333, 333, 333))
    Font.draw("my father. <3", screen, 0 * 8 + 4, 10 * 8, Color.get(0, 333, 333, 333))
end function

return AboutMenu
