Tile = {}
Tile.tickCount = 0
Tile.tiles = {}

// @param {int} id
// @returns {Tile}
Tile.make = function(id)
    self.connectsToGrass = false
    self.connectsToSand = false
    self.connectsToLava = false
    self.connectsToWater = false

    self.id = id
    qa.assert(not Tile.tiles.indexes.contains(id), "Duplicate tile ids!")
    Tile.tiles[id] = self

    return self
end function

// @param {Screen} screen
// @param {Level} level
// @param {int} x
// @param {int} y
Tile.render = function(screen, level, x, y)
end function

// @param {Level} level
// @param {int} x
// @param {int} y
// @param {Entity} e
// @returns {boolean}
Tile.mayPass = function(level, x, y, e)
    return true
end function

// @param {Level} level
// @param {int} x
// @param {int} y
// @returns {int}
Tile.getLightRadius = function(level, x, y)
    return 0
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Mob} source
// @param {int} dmg
// @param {int} attackDir
Tile.hurt = function(level, x, y, source, dmg, attackDir)
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Entity} entity
Tile.bumpedInto = function(level, xt, yt, entity)
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
Tile.tick = function(level, xt, yt)
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Entity} entity
Tile.steppedOn = function(level, xt, yt, entity)
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Player} player
// @param {Item} item
// @param {int} attackDir
// @returns {boolean}
Tile.interact = function(level, xt, yt, player, item, attackDir)
    return false
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Player} player
// @param {int} attackDir
// @returns {boolean}
Tile.use = function(level, xt, yt, player, attackDir)
    return false
end function

// @returns {boolean}
Tile.connectsToLiquid = function()
    return connectsToWater or connectsToLava
end function

return Tile
