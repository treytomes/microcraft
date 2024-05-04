HoleTile = new Tile

// @param {int} id
// @returns {Tile}
HoleTile.make = function(id)
    super.make(id)
    self.connectsToSand = true
    self.connectsToWater = true
    self.connectsToLava = true
end function

// @param {Screen} screen
// @param {Level} level
// @param {int} x
// @param {int} y
HoleTile.render = function(screen, level, x, y)
    col = Color.get(111, 111, 110, 110)
    transitionColor1 = Color.get(3, 111, level.dirtColor - 111, level.dirtColor)
    transitionColor2 = Color.get(3, 111, level.sandColor - 110, level.sandColor)

    u = not level.getTile(x, y - 1).connectsToLiquid
    d = not level.getTile(x, y + 1).connectsToLiquid
    l = not level.getTile(x - 1, y).connectsToLiquid
    r = not level.getTile(x + 1, y).connectsToLiquid

    su = u and level.getTile(x, y - 1).connectsToSand
    sd = d and level.getTile(x, y + 1).connectsToSand
    sl = l and level.getTile(x - 1, y).connectsToSand
    sr = r and level.getTile(x + 1, y).connectsToSand

    if not u and not l then
        screen.render(x * 16 + 0, y * 16 + 0, 0, col, 0)
    else
        screen.render(x * 16 + 0, y * 16 + 0, iif(l, 14, 15) + iif(u, 0, 1) * 32, iif(su or sl, transitionColor2, transitionColor1), 0)
    end if

    if not u and not r then
        screen.render(x * 16 + 8, y * 16 + 0, 1, col, 0)
    else
        screen.render(x * 16 + 8, y * 16 + 0, iif(r, 16, 15) + iif(u, 0, 1) * 32, iif(su or sr, transitionColor2, transitionColor1), 0)
    end if

    if not d and not l then
        screen.render(x * 16 + 0, y * 16 + 8, 2, col, 0)
    else
        screen.render(x * 16 + 0, y * 16 + 8, iif(l, 14, 15) + iif(d, 2, 1) * 32, iif(sd or sl, transitionColor2, transitionColor1), 0)
    end if
    if not d and not r then
        screen.render(x * 16 + 8, y * 16 + 8, 3, col, 0)
    else
        screen.render(x * 16 + 8, y * 16 + 8, iif(r, 16, 15) + iif(d, 2, 1) * 32, iif(sd or sr, transitionColor2, transitionColor1), 0)
    end if
end function

// @param {Level} level
// @param {int} x
// @param {int} y
// @param {Entity} e
// @returns {boolean}
HoleTile.mayPass = function(level, x, y, e)
    return e.canSwim
end function

return HoleTile
