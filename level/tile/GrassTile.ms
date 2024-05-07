GrassTile = new Tile

// @param {int} id
// @returns {Tile}
GrassTile.make = function(id)
    super.make(id)
    self.connectsToGrass = true
    return self
end function

// @param {Screen} screen
// @param {Level} level
// @param {int} x
// @param {int} y
GrassTile.render = function(screen, level, x, y)
    col = Color.get(level.grassColor, level.grassColor, level.grassColor + 111, level.grassColor + 111);
    transitionColor = Color.get(level.grassColor - 111, level.grassColor, level.grassColor + 111, level.dirtColor);

    u = not level.getTile(x, y - 1).connectsToGrass
    d = not level.getTile(x, y + 1).connectsToGrass
    l = not level.getTile(x - 1, y).connectsToGrass
    r = not level.getTile(x + 1, y).connectsToGrass

    if not u and not l then
        screen.render(x * 16 + 0, y * 16 + 0, 0, col, 0)
    else
        screen.render(x * 16 + 0, y * 16 + 0, iif(l, 11, 12) + iif(u, 0, 1) * 32, transitionColor, 0)
    end if

    if not u and not r then
        screen.render(x * 16 + 8, y * 16 + 0, 1, col, 0)
    else
        screen.render(x * 16 + 8, y * 16 + 0, iif(r, 13, 12) + iif(u, 0, 1) * 32, transitionColor, 0)
    end if

    if not d and not l then
        screen.render(x * 16 + 0, y * 16 + 8, 2, col, 0)
    else
        screen.render(x * 16 + 0, y * 16 + 8, iif(l, 11, 12) + iif(d, 2, 1) * 32, transitionColor, 0)
    end if

    if not d and not r then
        screen.render(x * 16 + 8, y * 16 + 8, 3, col, 0)
    else
        screen.render(x * 16 + 8, y * 16 + 8, iif(r, 13, 12) + iif(d, 2, 1) * 32, transitionColor, 0)
    end if
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
GrassTile.tick = function(level, xt, yt)
    if Random.nextInt(40) != 0 then return

    xn = xt
    yn = yt

    if Random.nextBoolean then
        xn += Random.nextInt(2) * 2 - 1
    else
        yn += Random.nextInt(2) * 2 - 1
    end if

    if level.getTile(xn, yn) == Tile.dirt then
        level.setTile(xn, yn, this, 0)
    end if
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Player} player
// @param {Item} item
// @param {int} attackDir
// @returns {boolean}
GrassTile.interact = function(level, xt, yt, player, item, attackDir)
    if item isa ToolItem then
        tool = item
        if tool.type == ToolType.shovel then
            if player.payStamina(4 - tool.level) then
                level.setTile(xt, yt, Tile.dirt, 0)
                Sounds.monsterHurt.play()
                if Random.nextInt(5) == 0 then
                    level.add((new ItemEntity).make((new ResourceItem).make(Resource.seeds), xt * 16 + Random.nextInt(10) + 3, yt * 16 + Random.nextInt(10) + 3))
                    return true
                end if
            end if
        end if
        if tool.type == ToolType.hoe then
            if player.payStamina(4 - tool.level) then
                Sounds.monsterHurt.play
                if Random.nextInt(5) == 0 then
                    level.add((new ItemEntity).make((new ResourceItem).make(Resource.seeds), xt * 16 + Random.nextInt(10) + 3, yt * 16 + Random.nextInt(10) + 3))
                    return true
                end if
                level.setTile(xt, yt, Tile.farmland, 0)
                return true
            end if
        end if
    end if
    return false
end function

return GrassTile
