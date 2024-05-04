WheatTile = new Tile

// @param {int} id
// @returns {Tile}
WheatTile.make = function(id)
    super.make(id)
    return self
end function

// @param {Screen} screen
// @param {Level} level
// @param {int} x
// @param {int} y
WheatTile.render = function(screen, level, x, y)
    age = level.getData(x, y)
    col = Color.get(level.dirtColor - 121, level.dirtColor - 11, level.dirtColor, 50)
    icon = floor(age / 10)
    if icon >= 3 then
        col = Color.get(level.dirtColor - 121, level.dirtColor - 11, 50 + (icon) * 100, 40 + (icon - 3) * 2 * 100)
        if age == 50 then
            col = Color.get(0, 0, 50 + (icon) * 100, 40 + (icon - 3) * 2 * 100)
        end if
        icon = 3
    end if

    screen.render(x * 16 + 0, y * 16 + 0, 4 + 3 * 32 + icon, col, 0)
    screen.render(x * 16 + 8, y * 16 + 0, 4 + 3 * 32 + icon, col, 0)
    screen.render(x * 16 + 0, y * 16 + 8, 4 + 3 * 32 + icon, col, 1)
    screen.render(x * 16 + 8, y * 16 + 8, 4 + 3 * 32 + icon, col, 1)
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
WheatTile.tick = function(level, xt, yt)
    if Random.nextInt(2) == 0 then return

    age = level.getData(xt, yt)
    if age < 50 then level.setData(xt, yt, age + 1)
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Player} player
// @param {Item} item
// @param {int} attackDir
// @returns {boolean}
WheatTile.interact = function(level, xt, yt, player, item, attackDir)
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
// @param {Entity} entity
WheatTile.steppedOn = function(level, xt, yt, entity)
    if Random.nextInt(60) != 0 then return
    if level.getData(xt, yt) < 2 then return
    self.harvest(level, xt, yt)
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Mob} source
// @param {int} dmg
// @param {int} attackDir
WheatTile.hurt = function(level, x, y, source, dmg, attackDir)
    self.harvest(level, x, y)
end function

// @param {Level} level
// @param {int} x
// @param {int} y
WheatTile.harvest = function(level, x, y)
    age = level.getData(x, y)

    count = Random.nextInt(2)
    for i in range(0, count - 1)
        level.add((new ItemEntity).make((new ResourceItem).make(Resource.seeds), x * 16 + Random.nextInt(10) + 3, y * 16 + Random.nextInt(10) + 3))
    end for

    count = 0
    if age == 50 then
        count = Random.nextInt(3) + 2
    else if age >= 40 then
        count = Random.nextInt(2) + 1
    end if
    for i in range(0, count - 1)
        level.add((new ItemEntity).make((new ResourceItem).make(Resource.wheat), x * 16 + Random.nextInt(10) + 3, y * 16 + Random.nextInt(10) + 3))
    end for

    level.setTile(x, y, Tile.dirt, 0)
end function

return WheatTile
