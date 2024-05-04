InfiniteFallTile = new Tile

// @param {int} id
// @returns {Tile}
InfiniteFallTile.make = function(id)
    super.make(id)
    return self
end function

// @param {Screen} screen
// @param {Level} level
// @param {int} x
// @param {int} y
InfiniteFallTile.render = function(screen, level, x, y)
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
InfiniteFallTile.tick = function(level, xt, yt)
end function

// @param {Level} level
// @param {int} x
// @param {int} y
// @param {Entity} e
// @returns {boolean}
InfiniteFallTile.mayPass = function(level, x, y, e)
    if e isa AirWizard then return true
    return false
end function

return InfiniteFallTile
