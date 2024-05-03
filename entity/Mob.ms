Mob = new Entity

Mob.make = function()
    self.walkDist = 0
    self.dir = 0
    self.hurtTime = 0
    self.xKnockback = 0
    self.yKnockback = 0
    self.maxHealth = 10
    self.health = maxHealth
    self.swimTimer = 0
    self.tickTime = 0

    self.x = 8
    self.y = 8
    self.xr = 4
    self.yr = 3
    return self
end function

Mob.tick = function()
    self.tickTime += 1
    if refEquals(self.level.getTile(floor(x / 16), floor(y / 16)), Tile.lava) then
        self.hurt(self, 4, bitXor(dir, 1));
    end if

    if self.health <= 0 then
        self.die()
    end if
    if self.hurtTime > 0 then self.hurtTime -= 1
end function

Mob.die = function()
    self.remove
end function

// @param {int} xa
// @param {int} ya
// @returns {boolean}
Mob.move = function(xa, ya)
    if self.isSwimming then
        self.swimTimer += 1
        if swimTimer % 2 == 0 then return true
    end if
    if self.xKnockback < 0 then
        self.move2(-1, 0)
        self.xKnockback += 1
    end if
    if self.xKnockback > 0 then
        self.move2(1, 0)
        self.xKnockback -= 1
    end if
    if self.yKnockback < 0 then
        self.move2(0, -1)
        self.yKnockback += 1
    end if
    if self.yKnockback > 0 then
        self.move2(0, 1)
        self.yKnockback -= 1
    end if
    if self.hurtTime > 0 then return true
    if self.xa != 0 or self.ya != 0 then
        walkDist += 1
        if self.xa < 0 then self.dir = 2
        if self.xa > 0 then self.dir = 3
        if self.ya < 0 then self.dir = 1
        if self.ya > 0 then self.dir = 0
    end if
    return super.move(self.xa, self.ya)
end function

// @returns {boolean} 
Mob.isSwimming = function()
    tile = self.level.getTile(floor(x / 16), floor(y / 16))
    return refEquals(tile, Tile.water) or refEquals(tile, Tile.lava)
end function

// @param {Entity} e
// @returns {boolean}
Mob.blocks = function(e)
    return e.isBlockableBy(self)
end function

// @param {Tile} tile
// @param {int} x
// @param {int} y
// @param {int} damage
Mob.hurt = function(tile, x, y, damage)
    attackDir = bitXor(dir, 1)
    self.doHurt(damage, attackDir)
end function

// @param {Mob} mob
// @param {int} damage
// @param {int} attackDir
Mob.hurt = function(mob, damage, attackDir)
    self.doHurt(damage, attackDir)
end function

// @param {int} heal
Mob.heal = function(heal)
    if self.hurtTime > 0 then return

    self.level.push((new TextParticle).make("" + heal, self.x, self.y, Color.get(-1, 50, 50, 50)))
    self.health += heal
    if self.health > self.maxHealth then self.health = self.maxHealth
end function

// @param {int} damage
// @param {int} attackDir
Mob.doHurt = function(damage, attackDir)
    if self.hurtTime > 0 then return

    if self.level.player != null then
        xd = self.level.player.x - self.x
        yd = self.level.player.y - self.y
        if xd * xd + yd * yd < 80 * 80 then
            Sound.monsterHurt.play()
        end if
    end if
    self.level.push((new TextParticle).make("" + damage, self.x, self.y, Color.get(-1, 500, 500, 500)))
    self.health -= damage
    if self.attackDir == 0 then self.yKnockback =  6
    if self.attackDir == 1 then self.yKnockback = -6
    if self.attackDir == 2 then self.xKnockback = -6
    if self.attackDir == 3 then self.xKnockback =  6
    self.hurtTime = 10
end function

// @param {Level} level
// @returns {boolean}
Mob.findStartPos = function(level)
    x = Random.nextInt(level.w)
    y = Random.nextInt(level.h)
    xx = x * 16 + 8
    yy = y * 16 + 8

    if level.player != null then
        xd = level.player.x - xx
        yd = level.player.y - yy
        if xd * xd + yd * yd < 80 * 80 then return false
    end if

    r = level.monsterDensity * 16
    if level.getEntities(xx - r, yy - r, xx + r, yy + r).len > 0 then return false

    if level.getTile(x, y).mayPass(level, x, y, self) then
        self.x = xx
        self.y = yy
        return true
    end if

    return false
end function

return Mob
