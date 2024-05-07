Slime = new Mob

// @param {int} lvl
// @returns {Slime}
Slime.make = function(lvl)
    super.make
    
    self.xa = 0
    self.ya = 0
    self.jumpTime = 0

    self.lvl = lvl
    self.x = Random.nextInt(64 * 16)
    self.y = Random.nextInt(64 * 16)
    self.maxHealth = lvl * lvl * 5
    self.health = self.maxHealth
    return self
end function

Slime.tick = function
    super.tick

    speed = 1
    if not self.move(self.xa * speed, self.ya * speed) or Random.nextInt(40) == 0 then
        if self.jumpTime <= -10 then
            self.xa = Random.nextInt(3) - 1
            self.ya = Random.nextInt(3) - 1

            if self.level.player != null then
                xd = self.level.player.x - self.x
                yd = self.level.player.y - self.y
                if xd * xd + yd * yd < 50 * 50 then
                    if xd < 0 then self.xa = -1
                    if xd > 0 then self.xa =  1
                    if yd < 0 then self.ya = -1
                    if yd > 0 then self.ya =  1
                end if
            end if

            if self.xa != 0 or self.ya != 0 then self.jumpTime = 10
        end if
    end if

    self.jumpTime -= 1
    if self.jumpTime == 0 then
        self.xa = 0
        self.ya = 0
    end if
end function

Slime.die = function
    super.die

    count = Random.nextInt(2) + 1
    for i in range(0, count - 1)
        self.level.add((new ItemEntity).make((new ResourceItem).make(Resource.slime), self.x + Random.nextInt(11) - 5, self.y + Random.nextInt(11) - 5))
    end for

    if self.level.player != null then
        self.level.player.score += 25 * self.lvl
    end if
end function

// @param {Screen} screen
Slime.render = function(screen)
    xt = 0
    yt = 18

    xo = self.x - 8
    yo = self.y - 11

    if self.jumpTime > 0 then
        xt += 2
        yo -= 4
    end if

    col = Color.get(-1, 10, 252, 555)
    if self.lvl == 2 then col = Color.get(-1, 100, 522, 555)
    if self.lvl == 3 then col = Color.get(-1, 111, 444, 555)
    if self.lvl == 4 then col = Color.get(-1, 000, 111, 224)

    if self.hurtTime > 0 then
        col = Color.get(-1, 555, 555, 555)
    end if

    screen.render(xo + 0, yo + 0, xt + yt * 32, col, 0)
    screen.render(xo + 8, yo + 0, xt + 1 + yt * 32, col, 0)
    screen.render(xo + 0, yo + 8, xt + (yt + 1) * 32, col, 0)
    screen.render(xo + 8, yo + 8, xt + 1 + (yt + 1) * 32, col, 0)
end function

// @param {Entity} entity
Slime.touchedBy = function(entity)
    if entity isa Player then
        entity.hurt(self, self.lvl, self.dir)
    end if
end function

return Slime
