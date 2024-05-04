CactusTile = new Tile

// @param {int} id
// @returns {CactusTile}
CactusTile.make = function(id)
    super.make(id)
    self.connectsToSand = true
    return self
end function

// @param {Screen} screen
// @param {Level} level
// @param {int} x
// @param {int} y
CactusTile.render = function(screen, level, x, y)
    col = Color.get(20, 40, 50, level.sandColor)
    screen.render(x * 16 + 0, y * 16 + 0, 8 + 2 * 32, col, 0)
    screen.render(x * 16 + 8, y * 16 + 0, 9 + 2 * 32, col, 0)
    screen.render(x * 16 + 0, y * 16 + 8, 8 + 3 * 32, col, 0)
    screen.render(x * 16 + 8, y * 16 + 8, 9 + 3 * 32, col, 0)
end function

// @param {Level} level
// @param {int} x
// @param {int} y
// @param {Entity} e
// @returns {boolean}
CactusTile.mayPass = function(level, x, y, e)
    return false
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Mob} source
// @param {int} dmg
// @param {int} attackDir
CactusTile.hurt = function(level, x, y, source, dmg, attackDir)
    damage = level.getData(x, y) + dmg
    level.add((new SmashParticle).push(x * 16 + 8, y * 16 + 8))
    level.add((new TextParticle).push("" + dmg, x * 16 + 8, y * 16 + 8, Color.get(-1, 500, 500, 500)))
    if damage >= 10 then
        count = Random.nextInt(2) + 1
        for i in range(0, count - 1)
            level.add((new ItemEntity).make((new ResourceItem).make(Resource.cactusFlower), x * 16 + Random.nextInt(10) + 3, y * 16 + Random.nextInt(10) + 3))
        end for
        level.setTile(x, y, Tile.sand, 0)
    else
        level.setData(x, y, damage)
    end if
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Entity} entity
CactusTile.bumpedInto = function(level, x, y, entity)
    entity.hurt(self, x, y, 1)
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
CactusTile.tick = function(level, xt, yt)
    damage = level.getData(xt, yt)
    if damage > 0 then level.setData(xt, yt, damage - 1)
end function

return CactusTile
