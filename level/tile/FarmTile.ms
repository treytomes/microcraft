FarmTile = new Tile

// @param {int} id
// @returns {FarmTile}
FarmTile.make = function(id)
    super.make(id)
    return self
end function

// @param {Screen} screen
// @param {Level} level
// @param {int} x
// @param {int} y
FarmTile.render = function(screen, level, x, y)
    col = Color.get(level.dirtColor - 121, level.dirtColor - 11, level.dirtColor, level.dirtColor + 111)
    screen.render(x * 16 + 0, y * 16 + 0, 2 + 32, col, 1)
    screen.render(x * 16 + 8, y * 16 + 0, 2 + 32, col, 0)
    screen.render(x * 16 + 0, y * 16 + 8, 2 + 32, col, 0)
    screen.render(x * 16 + 8, y * 16 + 8, 2 + 32, col, 1)
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Player} player
// @param {Item} item
// @param {int} attackDir
// @returns {boolean}
FarmTile.interact = function(level, xt, yt, player, item, attackDir)
    if item isa ToolItem then
        tool = item
        if tool.type == ToolType.shovel then
            if player.payStamina(4 - tool.level) then
                level.setTile(xt, yt, Tile.dirt, 0)
                return true
            end if
        end if
    end if
    return false
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
FarmTile.tick = function(level, xt, yt)
    age = level.getData(xt, yt)
    if age < 5 then level.setData(xt, yt, age + 1)
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Entity} entity
FarmTile.steppedOn = function(level, xt, yt, entity)
    if Random.nextInt(60) != 0 then return
    if level.getData(xt, yt) < 5 then return
    level.setTile(xt, yt, Tile.dirt, 0)
end function

return FarmTile
