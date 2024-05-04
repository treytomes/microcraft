StoneTile = new Tile

// @param {int} id
// @returns {Tile}
StoneTile.make = function(id)
    super.make(id)
    return self
end function

// @param {Screen} screen
// @param {Level} level
// @param {int} x
// @param {int} y
StoneTile.render = function(screen, level, x, y)
    rc1 = 111
    rc2 = 333
    rc3 = 555
    screen.render(x * 16 + 0, y * 16 + 0, 32, Color.get(rc1, level.dirtColor, rc2, rc3), 0)
    screen.render(x * 16 + 8, y * 16 + 0, 32, Color.get(rc1, level.dirtColor, rc2, rc3), 0)
    screen.render(x * 16 + 0, y * 16 + 8, 32, Color.get(rc1, level.dirtColor, rc2, rc3), 0)
    screen.render(x * 16 + 8, y * 16 + 8, 32, Color.get(rc1, level.dirtColor, rc2, rc3), 0)
end function

// @param {Level} level
// @param {int} x
// @param {int} y
// @param {Entity} e
// @returns {boolean}
StoneTile.mayPass = function(level, x, y, e)
    return false
end function

return StoneTile
