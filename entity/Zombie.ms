Zombie = new Mob

// @param {int} lvl
// @returns {Zombie}
Zombie.make = function(lvl)
    super.make
    
    self.xa = 0
    self.ya = 0
    self.randomWalkTime = 0
    self.lvl = lvl
    self.x = Random.nextInt(64 * 16)
    self.y = Random.nextInt(64 * 16)
    self.maxHealth = lvl * lvl * 10
    self.health = self.maxHealth
    return self
end function

Zombie.tick = function()
    super.tick()

    if self.level.player != null and self.randomWalkTime == 0 then
        xd = self.level.player.x - self.x
        yd = self.level.player.y - self.y
        if xd * xd + yd * yd < 50 * 50 then
            self.xa = 0
            self.ya = 0
            if xd < 0 then self.xa = -1
            if xd > 0 then self.xa =  1
            if yd < 0 then self.ya = -1
            if yd > 0 then self.ya =  1
        end if
    end if

    speed = bitAnd(self.tickTime, 1)
    if not self.move(self.xa * speed, self.ya * speed) or Random.nextInt(200) == 0 then
        self.randomWalkTime = 60
        self.xa = (Random.nextInt(3) - 1) * Random.nextInt(2)
        self.ya = (Random.nextInt(3) - 1) * Random.nextInt(2)
    end if
    if self.randomWalkTime > 0 then self.randomWalkTime -= 1
end function

// @param {Screen} screen
Zombie.render = function(screen)
    xt = 0
    yt = 14

    flip1 = bitAnd(floor(self.walkDist / 8), 1)
    flip2 = bitAnd(floor(self.walkDist / 8), 1)

    if self.dir == 1 then
        xt += 2
    end if
    if self.dir > 1 then
        flip1 = 0
        flip2 = bitAnd(floor(self.walkDist / 16), 1)
        if self.dir == 2 then
            flip1 = 1
        end if
        xt += 4 + bitAnd(floor(self.walkDist / 8), 1) * 2
    end if

    xo = self.x - 8
    yo = self.y - 11

    col = Color.get(-1, 10, 252, 050)
    if self.lvl == 2 then col = Color.get(-1, 100, 522, 050)
    if self.lvl == 3 then col = Color.get(-1, 111, 444, 050)
    if self.lvl == 4 then col = Color.get(-1, 000, 111, 020)
    if self.hurtTime > 0 then
        col = Color.get(-1, 555, 555, 555)
    end if

    screen.render(xo + 8 * flip1, yo + 0, xt + yt * 32, col, flip1)
    screen.render(xo + 8 - 8 * flip1, yo + 0, xt + 1 + yt * 32, col, flip1)
    screen.render(xo + 8 * flip2, yo + 8, xt + (yt + 1) * 32, col, flip2)
    screen.render(xo + 8 - 8 * flip2, yo + 8, xt + 1 + (yt + 1) * 32, col, flip2)
end function

// @param {Entity} entity
Zombie.touchedBy = function(entity)
    if entity isa Player then
        entity.hurt(self, self.lvl + 1, self.dir)
    end if
end function

Zombie.die = function()
    super.die

    count = Random.nextInt(2) + 1
    for i in range(0, count - 1)
        self.level.add((new ItemEntity).make((new ResourceItem).make(Resource.cloth), self.x + Random.nextInt(11) - 5, self.y + Random.nextInt(11) - 5))
    end for

    if self.level.player != null then
        self.level.player.score += 50 * self.lvl
    end if
end function

return Zombie
