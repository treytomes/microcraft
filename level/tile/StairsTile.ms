StairsTile = new Tile

// @param {int} id
// @param {boolean} leadsUp
// @returns {Tile}
StairsTile.make = function(id, leadsUp)
    super.make(id)
    self.leadsUp = leadsUp
    return self
end function

// @param {Screen} screen
// @param {Level} level
// @param {int} x
// @param {int} y
StairsTile.render = function(screen, level, x, y)
    color = Color.get(level.dirtColor, 000, 333, 444)
    xt = 0
    if self.leadsUp then xt = 2
    screen.render(x * 16 + 0, y * 16 + 0, xt + 2 * 32, color, 0)
    screen.render(x * 16 + 8, y * 16 + 0, xt + 1 + 2 * 32, color, 0)
    screen.render(x * 16 + 0, y * 16 + 8, xt + 3 * 32, color, 0)
    screen.render(x * 16 + 8, y * 16 + 8, xt + 1 + 3 * 32, color, 0)
end function

return StairsTile
