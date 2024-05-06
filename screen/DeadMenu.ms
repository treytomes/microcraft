DeadMenu = new Menu

// @returns {DeadMenu}
DeadMenu.make = function()
    self.inputDelay = 60
    return self
end function

DeadMenu.tick = function
    if self.inputDelay > 0 then
        self.inputDelay -= 1
    else if self.input.attack.clicked or self.input.menu.clicked then
        game.setMenu((new TitleMenu).make())
    end if
end function

// @param {Screen} screen
DeadMenu.render = function(screen)
    Font.renderFrame(screen, "", 1, 3, 18, 9)
    Font.draw("You died! Aww!", screen, 2 * 8, 4 * 8, Color.get(-1, 555, 555, 555))

    seconds = floor(game.gameTime / 60)
    minutes = floor(seconds / 60)
    hours = floor(minutes / 60)
    minutes %= 60
    seconds %= 60

    timeString = ""
    if hours > 0 then
        timeString = hours + "h" + iif(minutes < 10, "0", "") + minutes + "m"
    else
        timeString = minutes + "m " + iif(seconds < 10, "0", "") + seconds + "s"
    end if
    Font.draw("Time:", screen, 2 * 8, 5 * 8, Color.get(-1, 555, 555, 555))
    Font.draw(timeString, screen, (2 + 5) * 8, 5 * 8, Color.get(-1, 550, 550, 550))
    Font.draw("Score:", screen, 2 * 8, 6 * 8, Color.get(-1, 555, 555, 555))
    Font.draw("" + game.player.score, screen, (2 + 6) * 8, 6 * 8, Color.get(-1, 550, 550, 550))
    Font.draw("Press C to lose", screen, 2 * 8, 8 * 8, Color.get(-1, 333, 333, 333))
end function

return DeadMenu
