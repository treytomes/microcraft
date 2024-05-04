SaplingTile = new Tile

// @param {int} id
// @param {Tile} onType
// @param {Tile} growsTo
// @returns {Tile}
SaplingTile.make = function(id, onType, growsTo)
    super.make(id)
    self.onType = onType
    self.growsTo = growsTo
    self.connectsToSand = onType.connectsToSand
    self.connectsToGrass = onType.connectsToGrass
    self.connectsToWater = onType.connectsToWater
    self.connectsToLava = onType.connectsToLava
    return self
end function

// @param {Screen} screen
// @param {Level} level
// @param {int} x
// @param {int} y
SaplingTile.render = function(screen, level, x, y)
    onType.render(screen, level, x, y)
    col = Color.get(10, 40, 50, -1)
    screen.render(x * 16 + 4, y * 16 + 4, 11 + 3 * 32, col, 0)
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
SaplingTile.tick = function(level, xt, yt)
    age = level.getData(x, y) + 1
    if age > 100 then
        level.setTile(x, y, growsTo, 0)
    else
        level.setData(x, y, age)
    end if
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Mob} source
// @param {int} dmg
// @param {int} attackDir
SaplingTile.hurt = function(level, x, y, source, dmg, attackDir)
    level.setTile(x, y, self.onType, 0)
end function

return SaplingTile
