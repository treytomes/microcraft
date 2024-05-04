AirWizard = new Mob

// @returns {AirWizard}
AirWizard.make = function
    self.xa = 0
    self.ya = 0
    self.randomWalkTime = 0
    self.attackDelay = 0
    self.attackTime = 0
    self.attackType = 0

    self.x = Random.nextInt(64 * 16)
    self.y = Random.nextInt(64 * 16)
    self.maxHealth = 2000
    self.health = self.maxHealth

    return self
end function

AirWizard.tick = function()
    super.tick

    if self.attackDelay > 0 then
        self.dir = (self.attackDelay - 45) / 4 % 4
        self.dir = (self.dir * 2 % 4) + (self.dir / 2)
        if self.attackDelay < 45 then
            dir = 0
        end if
        self.attackDelay -= 1
        if self.attackDelay == 0 then
            self.attackType = 0
            if self.health < 1000 then self.attackType = 1
            if self.health < 200 then self.attackType = 2
            self.attackTime = 60 * 2
        end if
        return
    end if

    if self.attackTime > 0 then
        self.attackTime -= 1
        dir = self.attackTime * 0.25 * (self.attackTime % 2 * 2 - 1)
        speed = (0.7) + self.attackType * 0.2
        self.level.add((new Spark).make(self, cos(dir) * speed, sin(dir) * speed))
        return
    end if

    if self.level.player != null and self.randomWalkTime == 0 then
        xd = self.level.player.x - self.x
        yd = self.level.player.y - self.y
        if xd * xd + yd * yd < 32 * 32 then
            self.xa = 0
            self.ya = 0
            if xd < 0 then self.xa =  1
            if xd > 0 then self.xa = -1
            if yd < 0 then self.ya =  1
            if yd > 0 then self.ya = -1
        else if xd * xd + yd * yd > 80 * 80 then
            self.xa = 0
            self.ya = 0
            if xd < 0 then self.xa = -1
            if xd > 0 then self.xa =  1
            if yd < 0 then self.ya = -1
            if yd > 0 then self.ya =  1
        end if
    end if

    if (self.tickTime % 4) == 0 then speed = 0 else speed = 1
    if not self.move(self.xa * speed, self.ya * speed) or Random.nextInt(100) == 0 then
        self.randomWalkTime = 30
        self.xa = (Random.nextInt(3) - 1)
        self.ya = (Random.nextInt(3) - 1)
    end if
    if self.randomWalkTime > 0 then
        self.randomWalkTime -= 1
        if self.level.player != null and self.randomWalkTime == 0 then
            xd = self.level.player.x - self.x
            yd = self.level.player.y - self.y
            if Random.nextInt(4) == 0 and xd * xd + yd * yd < 50 * 50 then
                if self.attackDelay == 0 and self.attackTime == 0 then
                    self.attackDelay = 60 * 2
                end if
            end if
        end if
    end if
end function

// @param {int} damage
// @param {int} attackDir
AirWizard.doHurt = function(damage, attackDir)
    super.doHurt(damage, attackDir)
    if self.attackDelay == 0 and self.attackTime == 0 then
        self.attackDelay = 60 * 2
    end if
end function

// @param {Screen} screen
AirWizard.render = function(screen)
    xt = 8
    yt = 14

    flip1 = bitAnd(floor(walkDist / 8 ), 1)
    flip2 = bitAnd(floor(walkDist / 8), 1)

    if self.dir == 1 then
        xt += 2
    end if
    if self.dir > 1 then
        flip1 = 0
        flip2 = bitAnd(floor(self.walkDist / 16), 1)
        if self.dir == 2 then
            flip1 = 1
        end if
        xt += 4 + bitAnd(floor(walkDist / 8), 1) * 2
    end if

    xo = x - 8
    yo = y - 11

    col1 = Color.get(-1, 100, 500, 555)
    col2 = Color.get(-1, 100, 500, 532)
    if self.health < 200 then
        if self.tickTime / 3 % 2 == 0 then
            col1 = Color.get(-1, 500, 100, 555)
            col2 = Color.get(-1, 500, 100, 532)
        end if
    else if self.health < 1000 then
        if self.tickTime / 5 % 4 == 0 then
            col1 = Color.get(-1, 500, 100, 555)
            col2 = Color.get(-1, 500, 100, 532)
        end if
    end if
    if self.hurtTime > 0 then
        col1 = Color.get(-1, 555, 555, 555)
        col2 = Color.get(-1, 555, 555, 555)
    end if

    screen.render(xo + 8 * flip1, yo + 0, xt + yt * 32, col1, flip1)
    screen.render(xo + 8 - 8 * flip1, yo + 0, xt + 1 + yt * 32, col1, flip1)
    screen.render(xo + 8 * flip2, yo + 8, xt + (yt + 1) * 32, col2, flip2)
    screen.render(xo + 8 - 8 * flip2, yo + 8, xt + 1 + (yt + 1) * 32, col2, flip2)
end function

// @param {Entity} entity
AirWizard.touchedBy = function(entity)
    if entity isa Player then
        entity.hurt(self, 3, self.dir)
    end if
end function

AirWizard.die = function
    super.die
    if game.level.player != null then
        game.level.player.score += 1000
        game.level.player.gameWon
    end if
    Sound.bossdeath.play
end function

return AirWizard
