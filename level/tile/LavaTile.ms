LavaTile = new Tile

// @param {int} id
// @returns {Tile}
LavaTile.make = function(id)
    super.make(id)
    self.connectsToSand = true
    self.connectsToLava = true
    return self
end function

// @param {Screen} screen
// @param {Level} level
// @param {int} x
// @param {int} y
LavaTile.render = function(screen, level, x, y)
    // TODO: I'm not implementing this bit right now, but validate the appearance of lava tiles.
    // wRandom.setSeed((tickCount + (x / 2 - y) * 4311) / 10 * 54687121l + x * 3271612l + y * 3412987161l)
    col = Color.get(500, 500, 520, 550)
    transitionColor1 = Color.get(3, 500, level.dirtColor - 111, level.dirtColor)
    transitionColor2 = Color.get(3, 500, level.sandColor - 110, level.sandColor)

    u = not level.getTile(x, y - 1).connectsToLava
    d = not level.getTile(x, y + 1).connectsToLava
    l = not level.getTile(x - 1, y).connectsToLava
    r = not level.getTile(x + 1, y).connectsToLava

    su = u and level.getTile(x, y - 1).connectsToSand
    sd = d and level.getTile(x, y + 1).connectsToSand
    sl = l and level.getTile(x - 1, y).connectsToSand
    sr = r and level.getTile(x + 1, y).connectsToSand

    if not u and not l then
        screen.render(x * 16 + 0, y * 16 + 0, Random.nextInt(4), col, Random.nextInt(4))
    else
        screen.render(x * 16 + 0, y * 16 + 0, iif(l, 14, 15) + iif(u, 0, 1) * 32, iif(su or sl, transitionColor2, transitionColor1), 0)
    end if

    if not u and not r then
        screen.render(x * 16 + 8, y * 16 + 0, Random.nextInt(4), col, Random.nextInt(4))
    else
        screen.render(x * 16 + 8, y * 16 + 0, iif(r, 16, 15) + iif(u, 0, 1) * 32, iif(su or sr, transitionColor2, transitionColor1), 0)
    end if

    if not d and not l then
        screen.render(x * 16 + 0, y * 16 + 8, Random.nextInt(4), col, Random.nextInt(4))
    else
        screen.render(x * 16 + 0, y * 16 + 8, iif(l, 14, 15) + iif(d, 2, 1) * 32, iif(sd or sl, transitionColor2, transitionColor1), 0)
    end if
    if not d and not r then
        screen.render(x * 16 + 8, y * 16 + 8, Random.nextInt(4), col, Random.nextInt(4))
    else
        screen.render(x * 16 + 8, y * 16 + 8, iif(r, 16, 15) + iif(d, 2, 1) * 32, iif(sd or sr, transitionColor2, transitionColor1), 0)
    end if
end function

// @param {Level} level
// @param {int} x
// @param {int} y
// @param {Entity} e
// @returns {boolean}
LavaTile.mayPass = function(level, x, y, e)
    return e.canSwim
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
LavaTile.tick = function(level, xt, yt)
    xn = xt
    yn = yt

    if Random.nextBoolean then
        xn += Random.nextInt(2) * 2 - 1
    else
        yn += Random.nextInt(2) * 2 - 1
    end if

    if level.getTile(xn, yn) == Tile.hole then
        level.setTile(xn, yn, this, 0)
    end if
end function

// @param {Level} level
// @param {int} x
// @param {int} y
// @returns {int}
LavaTile.getLightRadius = function(level, x, y)
    return 6
end function

return LavaTile
