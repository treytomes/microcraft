LevelGen = {}

// @param {int} w
// @param {int} h
// @param {int} featureSize
LevelGen.make = function(w, h, featureSize)
    self.w = w
    self.h = h

    self.values = [0] * w * h

    for y in range(0, w - 1, featureSize) // TODO: Should this be `h`?
        for x in range(0, w - 1, featureSize)
            self.setSample(x, y, Random.nextFloat * 2 - 1)
        end for
    end for

    stepSize = featureSize
    scale = 1.0 / w
    scaleMod = 1
    while true
        halfStep = stepSize / 2
        for y in range(0, w - 1, stepSize)
            for x in range(0, w - 1, stepSize)
                a = self.sample(x, y)
                b = self.sample(x + stepSize, y)
                c = self.sample(x, y + stepSize)
                d = self.sample(x + stepSize, y + stepSize)

                e = (a + b + c + d) / 4.0 + (Random.nextFloat * 2 - 1) * stepSize * scale
                self.setSample(x + halfStep, y + halfStep, e)
            end for
        end for
        for y in range(0, w - 1, stepSize)
            for x in range(0, w - 1, stepSize)
                a = self.sample(x, y)
                b = self.sample(x + stepSize, y)
                c = self.sample(x, y + stepSize)
                d = self.sample(x + halfStep, y + halfStep)
                e = self.sample(x + halfStep, y - halfStep)
                f = self.sample(x - halfStep, y + halfStep)

                H = (a + b + d + e) / 4.0 + (Random.nextFloat * 2 - 1) * stepSize * scale * 0.5
                g = (a + c + d + f) / 4.0 + (Random.nextFloat * 2 - 1) * stepSize * scale * 0.5
                self.setSample(x + halfStep, y, H)
                self.setSample(x, y + halfStep, g)
            end for
        end for
        stepSize /= 2
        scale *= (scaleMod + 0.8)
        scaleMod *= 0.3

        if stepSize <= 1 then break
    end while

    return self
end function

// @param {int} x
// @param {int} y
// @returns {int}
LevelGen.sample = function(x, y)
    return self.values[bitAnd(x, (self.w - 1)) + bitAnd(y, (self.h - 1)) * w]
end function

// @param {int} x
// @param {int} y
// @param {double} value
LevelGen.setSample = function(x, y, value)
    self.values[bitAnd(x, (self.w - 1)) + bitAnd(y, (self.h - 1)) * self.w] = value
end function

// @param {int} w
// @param {int} h
// @returns {byte[][]}
LevelGen.createAndValidateTopMap = function(w, h)
    attempt = 0
    while true
        result = self.createTopMap(w, h)

        count = [0] * 256

        for i in range(0, w * h - 1)
            count[bitAnd(result[0][i], 255)] += 1
        end for
        if count[bitAnd(Tile.rock.id, 255)] < 100 then continue
        if count[bitAnd(Tile.sand.id, 255)] < 100 then continue
        if count[bitAnd(Tile.grass.id, 255)] < 100 then continue
        if count[bitAnd(Tile.tree.id, 255)] < 100 then continue
        if count[bitAnd(Tile.stairsDown.id, 255)] < 2 then continue

        return result
    end while
end function

// @param {int} w
// @param {int} h
// @param {int} depth
// @returns {byte[][]}
LevelGen.createAndValidateUndergroundMap = function(w, h, depth)
    attempt = 0
    while true
        result = self.createUndergroundMap(w, h, depth)

        count = [0] * 256

        for i in range(w * h - 1)
            count[bitAnd(result[0][i], 255)] += 1
        end for
        if count[bitAnd(Tile.rock.id, 255)] < 100 then continue
        if count[bitAnd(Tile.dirt.id, 255)] < 100 then continue
        if count[bitAnd(Tile.ironOre.id, 255) + depth - 1] < 20 then continue
        if depth < 3 then
            if count[bitAnd(Tile.stairsDown.id, 255)] < 2 then continue
        end if

        return result
    end while
end function

// @param {int} w
// @param {int} h
// @returns {byte[][]}
LevelGen.createAndValidateSkyMap = function(w, h)
    attempt = 0
    while true
        result = self.createSkyMap(w, h)

        count = [0] * 256

        for i in range(w * h - 1)
            count[bitAnd(result[0][i], 255)] += 1
        end for
        if count[bitAnd(Tile.cloud.id, 255)] < 2000 then continue
        if count[bitAnd(Tile.stairsDown.id, 255)] < 2 then continue

        return result
    end while
end function

// @param {int} w
// @param {int} h
// @returns {byte[][]}
LevelGen.createTopMap = function(w, h)
    mnoise1 = (new LevelGen).make(w, h, 16)
    mnoise2 = (new LevelGen).make(w, h, 16)
    mnoise3 = (new LevelGen).make(w, h, 16)

    noise1 = (new LevelGen).make(w, h, 32)
    noise2 = (new LevelGen).make(w, h, 32)

    map = [0] * w * h
    data = [0] * w * h
    for y in range(0, h - 1)
        for x in range(0, w - 1)
            i = x + y * w

            val = abs(noise1.values[i] - noise2.values[i]) * 3 - 2
            mval = abs(mnoise1.values[i] - mnoise2.values[i])
            mval = abs(mval - mnoise3.values[i]) * 3 - 2

            xd = x / (w - 1.0) * 2 - 1
            yd = y / (h - 1.0) * 2 - 1
            if xd < 0 then xd = -xd // TODO: Why not abs here?
            if yd < 0 then yd = -yd
            if xd >= yd then
                dist = xd
            else
                dist = yd
            end if
            dist = dist * dist * dist * dist
            dist = dist * dist * dist * dist
            val = val + 1 - dist * 20

            if val < -0.5 then
                map[i] = Tile.water.id
            else if val > 0.5 and mval < -1.5 then
                map[i] = Tile.rock.id
            else
                map[i] = Tile.grass.id
            end if
        end for
    end for

    for i in range(w * h / 2800 - 1)
        xs = Random.nextInt(w)
        ys = Random.nextInt(h)
        for k in range(0, 10 - 1)
            x = xs + Random.nextInt(21) - 10
            y = ys + Random.nextInt(21) - 10
            for j in range(0, 100 - 1)
                xo = x + Random.nextInt(5) - Random.nextInt(5)
                yo = y + Random.nextInt(5) - Random.nextInt(5)
                for yy in range(yo - 1, yo + 1)
                    for xx in range(xo - 1, xo + 1)
                        if xx >= 0 and yy >= 0 and xx < w and yy < h then
                            if map[xx + yy * w] == Tile.grass.id then 
                                map[xx + yy * w] = Tile.sand.id
                            end if
                        end if
                    end for
                end for
            end for
        end for
    end for

    for i in range(0, w * h / 400 - 1)
        x = Random.nextInt(w)
        y = Random.nextInt(h)
        for j in range(0, 200 - 1)
            xx = x + Random.nextInt(15) - Random.nextInt(15)
            yy = y + Random.nextInt(15) - Random.nextInt(15)
            if xx >= 0 and yy >= 0 and xx < w and yy < h then
                if map[xx + yy * w] == Tile.grass.id then
                    map[xx + yy * w] = Tile.tree.id
                end if
            end if
        end for
    end for

    for i in range(w * h / 400 - 1)
        x = Random.nextInt(w)
        y = Random.nextInt(h)
        col = Random.nextInt(4)
        for j in range(0, 30 - 1)
            xx = x + Random.nextInt(5) - Random.nextInt(5)
            yy = y + Random.nextInt(5) - Random.nextInt(5)
            if xx >= 0 and yy >= 0 and xx < w and yy < h then
                if map[xx + yy * w] == Tile.grass.id then
                    map[xx + yy * w] = Tile.flower.id
                    data[xx + yy * w] = col + Random.nextInt(4) * 16
                end if
            end if
        end for
    end for

    for i in range(w * h / 100 - 1)
        xx = Random.nextInt(w)
        yy = Random.nextInt(h)
        if xx >= 0 and yy >= 0 and xx < w and yy < h then
            if map[xx + yy * w] == Tile.sand.id then
                map[xx + yy * w] = Tile.cactus.id
            end if
        end if
    end for

    count = 0
    for i in range(w * h / 100 - 1)
        x = Random.nextInt(w - 2) + 1
        y = Random.nextInt(h - 2) + 1

        notRock = false
        for yy in range(y - 1, y + 1)
            for xx in range(x - 1, x + 1)
                if map[xx + yy * w] != Tile.rock.id then
                    notRock = true
                    break
                end if
            end for
            if notRock then break
        end for
        if notRock then continue

        map[x + y * w] = Tile.stairsDown.id
        count += 1
        if count == 4 then break
    end for

    return [ map, data ]
end function

// @param {int} w
// @param {int} h
// @param {int} depth
// @returns {byte[][]}
LevelGen.createUndergroundMap = function(w, h, depth)
    mnoise1 = (new LevelGen).make(w, h, 16)
    mnoise2 = (new LevelGen).make(w, h, 16)
    mnoise3 = (new LevelGen).make(w, h, 16)

    nnoise1 = (new LevelGen).make(w, h, 16)
    nnoise2 = (new LevelGen).make(w, h, 16)
    nnoise3 = (new LevelGen).make(w, h, 16)

    wnoise1 = (new LevelGen).make(w, h, 16)
    wnoise2 = (new LevelGen).make(w, h, 16)
    wnoise3 = (new LevelGen).make(w, h, 16)

    noise1 = (new LevelGen).make(w, h, 32)
    noise2 = (new LevelGen).make(w, h, 32)

    map = [0] * w * h
    data = [0] * w * h
    for y in range(0, h - 1)
        for x in range(0, w - 1)
            i = x + y * w

            val = abs(noise1.values[i] - noise2.values[i]) * 3 - 2

            mval = abs(mnoise1.values[i] - mnoise2.values[i])
            mval = abs(mval - mnoise3.values[i]) * 3 - 2

            nval = abs(nnoise1.values[i] - nnoise2.values[i])
            nval = abs(nval - nnoise3.values[i]) * 3 - 2

            wval = abs(wnoise1.values[i] - wnoise2.values[i])
            wval = abs(nval - wnoise3.values[i]) * 3 - 2

            xd = x / (w - 1.0) * 2 - 1
            yd = y / (h - 1.0) * 2 - 1
            if xd < 0 then xd = -xd // TODO: Why not abs here?
            if yd < 0 then yd = -yd
            if xd >= yd then
                dist = xd
            else
                dist = yd
            end if
            dist = dist * dist * dist * dist
            dist = dist * dist * dist * dist
            val = val + 1 - dist * 20

            if val > -2 and wval < -2.0 + depth / 2 * 3 then
                if depth > 2 then
                    map[i] = Tile.lava.id
                else
                    map[i] = Tile.water.id
                end if
            else if val > -2 and (mval < -1.7 or nval < -1.4) then
                map[i] = Tile.dirt.id
            else
                map[i] = Tile.rock.id
            end if
        end for
    end for

    r = 2
    for i in range(w * h / 400 - 1)
        x = Random.nextInt(w)
        y = Random.nextInt(h)
        for j in range(0, 30 - 1)
            xx = x + Random.nextInt(5) - Random.nextInt(5)
            yy = y + Random.nextInt(5) - Random.nextInt(5)
            if xx >= r and yy >= r and xx < w - r and yy < h - r then
                if map[xx + yy * w] == Tile.rock.id then
                    map[xx + yy * w] = bitAnd(Tile.ironOre.id, 255) + depth - 1
                end if
            end if
        end for
    end for

    if depth < 3 then
        count = 0
        for i in range(w * h / 100 - 1)
            x = Random.nextInt(w - 2) + 1
            y = Random.nextInt(h - 2) + 1

            notRock = false
            for yy in range(y - 1, y + 1)
                for xx in range(x - 1, x + 1)
                    if map[xx + yy * w] != Tile.rock.id then
                        notRock = true
                        break
                    end if
                end for
                if notRock then break
            end for
            if notRock then continue

            map[x + y * w] = Tile.stairsDown.id
            count += 1
            if count == 4 then break
        end for
    end if

    return [ map, data ]
end function

// @param {int} w
// @param {int} h
// @returns {byte[][]}
LevelGen.createSkyMap = function(w, h)
    noise1 = (new LevelGen).make(w, h, 8)
    noise2 = (new LevelGen).make(w, h, 8)

    map = [0] * w * h
    data = [0] * w * h
    for y in range(0, h - 1)
        for x in range(0, w - 1)
            i = x + y * w

            val = abs(noise1.values[i] - noise2.values[i]) * 3 - 2

            xd = x / (w - 1.0) * 2 - 1
            yd = y / (h - 1.0) * 2 - 1
            if xd < 0 then xd = -xd
            if yd < 0 then yd = -yd
            if xd >= yd then
                dist = xd
            else
                dist = yd
            end if
            dist = dist * dist * dist * dist
            dist = dist * dist * dist * dist
            val = -val * 1 - 2.2
            val = val + 1 - dist * 20

            if val < -0.25 then
                map[i] = Tile.infiniteFall.id
            else
                map[i] = Tile.cloud.id
            end if
        end for
    end for

    for i in range(0, w * h / 50 - 1)
        x = Random.nextInt(w - 2) + 1
        y = Random.nextInt(h - 2) + 1

        notCloud = false
        for yy in range(y - 1, y + 1)
            for xx in range(x - 1, x + 1)
                if map[xx + yy * w] != Tile.cloud.id then
                    notCloud = true
                    break
                end if
            end for
            if notCloud then break
        end for
        if notCloud then continue

        map[x + y * w] = Tile.cloudCactus.id
    end for

    count = 0
    for i in range(0, w * h)
        x = Random.nextInt(w - 2) + 1
        y = Random.nextInt(h - 2) + 1

        notCloud = false
        for yy in range(y - 1, y + 1)
            for xx in range(x - 1, x + 1)
                if map[xx + yy * w] != Tile.cloud.id then
                    notCloud = true
                    break
                end if
            end for
            if notCloud then break
        end for
        if notCloud then continue

        map[x + y * w] = Tile.stairsDown.id
        count += 1
        if count == 2 then break
    end for

    return [ map, data ]
end function

main = function
    d = 0

    w = 128
    h = 128

    text.clear
    gfx.clear

    map = LevelGen.createAndValidateTopMap(w, h)[0]
    // map = LevelGen.createAndValidateUndergroundMap(w, h, (d++ % 3) + 1)[0]
    // map = LevelGen.createAndValidateSkyMap(w, h)[0]
    for y in range(0, h - 1)
        for x in range(0, w - 1)
            i = x + y * w

            if map[i] == Tile.water.id then setPixel(x, y, "#000080")
            if map[i] == Tile.grass.id then setPixel(x, y, "#208020")
            if map[i] == Tile.rock.id then setPixel(x, y, "#a0a0a0")
            if map[i] == Tile.dirt.id then setPixel(x, y, "#604040")
            if map[i] == Tile.sand.id then setPixel(x, y, "#a0a040")
            if map[i] == Tile.tree.id then setPixel(x, y, "#003000")
            if map[i] == Tile.lava.id then setPixel(x, y, "#ff2020")
            if map[i] == Tile.cloud.id then setPixel(x, y, "#a0a0a0")
            if map[i] == Tile.stairsDown.id then setPixel(x, y, "#ffffff")
            if map[i] == Tile.stairsUp.id then setPixel(x, y, "#ffffff")
            if map[i] == Tile.cloudCactus.id then setPixel(x, y, "#ff00ff")
        end for
    end for
end function

if locals == globals then
    main
else
    return LevelGen
end if