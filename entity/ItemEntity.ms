ItemEntity = new Entity

// @param {Item} item
// @param {int} x
// @param {int} y
// @returns {ItemEntity}
ItemEntity.make = function(item, x, y)
    super.make
    
    self.time = 0
    self.xKnockback = 0
    self.yKnockback = 0
    self.hurtTime = 0
    self.dir = 0
    self.walkDist = 0

    self.item = item
    self.x = x
    self.y = y
    self.xx = x
    self.yy = y
    self.xr = 3
    self.yr = 3

    self.zz = 2
    self.xa = Random.nextGaussian() * 0.3
    self.ya = Random.nextGaussian() * 0.2
    self.za = Random.nextFloat() * 0.7 + 1

    self.lifeTime = 60 * 10 + Random.nextInt(60)
    return self
end function

ItemEntity.tick = function()
    self.time += 1
    if self.time >= self.lifeTime then
        self.remove
        return
    end if
    self.xx += self.xa
    self.yy += self.ya
    self.zz += self.za
    if self.zz < 0 then
        self.zz = 0
        self.za *= -0.5
        self.xa *= 0.6
        self.ya *= 0.6
    end if
    self.za -= 0.15
    ox = self.x
    oy = self.y
    nx = floor(self.xx)
    ny = floor(self.yy)
    expectedX = nx - self.x
    expectedY = ny - self.y
    self.move(nx - self.x, ny - self.y)
    gotX = self.x - ox
    gotY = self.y - oy
    self.xx += gotX - expectedX
    self.yy += gotY - expectedY

    if self.hurtTime > 0 then self.hurtTime -= 1
end function

// @param {Mob} mob
// @returns {boolean}
ItemEntity.isBlockableBy = function(mob)
    return false
end function

// @param {Screen} screen
ItemEntity.render = function(screen)
    if self.time >= self.lifeTime - 6 * 20 then
        if floor(self.time / 6) % 2 == 0 then return
    end if
    screen.render(self.x - 4, self.y - 4, self.item.getSprite(), Color.get(-1, 0, 0, 0), 0)
    screen.render(self.x - 4, self.y - 4 - floor(self.zz), self.item.getSprite(), self.item.getColor(), 0)
end function

// @param {Entity} entity
ItemEntity.touchedBy = function(entity)
    if self.time > 30 then entity.touchItem(self)
end function

// @param {Player} player
ItemEntity.take = function(player)
    Sounds.pickup.play
    player.score += 1
    self.item.onTake(self)
    self.remove
end function

return ItemEntity
