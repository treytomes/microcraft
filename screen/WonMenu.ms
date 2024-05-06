WonMenu = new Menu

// @returns {WonMenu}
WonMenu.make = function
    self.inputDelay = 60
    return self
end function

WonMenu.tick = function
    if self.inputDelay > 0 then
        inputDelay -= 1
    else if self.input.attack.clicked or self.input.menu.clicked then
        self.game.setMenu((new TitleMenu).make)
    end if
end function

// @param {Screen} screen
WonMenu.render = function(screen)
    Font.renderFrame(screen, "", 1, 3, 18, 9)
    Font.draw("You won! Yay!", screen, 2 * 8, 4 * 8, Color.get(-1, 555, 555, 555))

    seconds = floor(self.game.gameTime / 60)
    minutes = floor(seconds / 60)
    hours = minutes / 60
    minutes %= 60
    seconds %= 60

    timeString = ""
    if self.hours > 0 then
        timeString = hours + "h" + iif(minutes < 10, "0", "") + minutes + "m"
    else
        timeString = minutes + "m " + iif(seconds < 10, "0", "") + seconds + "s"
    end if
    Font.draw("Time:", screen, 2 * 8, 5 * 8, Color.get(-1, 555, 555, 555))
    Font.draw(timeString, screen, (2 + 5) * 8, 5 * 8, Color.get(-1, 550, 550, 550))
    Font.draw("Score:", screen, 2 * 8, 6 * 8, Color.get(-1, 555, 555, 555))
    Font.draw("" + self.game.player.score, screen, (2 + 6) * 8, 6 * 8, Color.get(-1, 550, 550, 550))
    Font.draw("Press C to win", screen, 2 * 8, 8 * 8, Color.get(-1, 333, 333, 333))
end function

return WonMenu
