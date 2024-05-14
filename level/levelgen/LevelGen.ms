LevelGen = {}

// @param {int} w
// @param {int} h
// @param {int} featureSize
LevelGen.make = function(w, h, featureSize)
    // startTime = time
    
    self.w = w
    self.h = h

    self.values = [0] * w * h

    for y in range(0, h - 1, featureSize)
        for x in range(0, w - 1, featureSize)
            offset = (x + y * self.w) % self.values.len
            self.values[offset] = rnd * 2 - 1
        end for
    end for
    // print "  seed:{0}".fill([time-startTime]);startTime=time

    stepSize = featureSize
    scale = 1.0 / w
    scaleMod = 1
    while stepSize > 1
        halfStep = stepSize / 2
        for y in range(0, h - 1, stepSize)
            for x in range(0, w - 1, stepSize)
                a = self.sample(x, y)
                b = self.sample(x + stepSize, y)
                c = self.sample(x, y + stepSize)
                d = self.sample(x + stepSize, y + stepSize)

                e = (a + b + c + d) / 4.0 + (rnd * 2 - 1) * stepSize * scale
                self.setSample(x + halfStep, y + halfStep, e)

                a = self.sample(x, y)
                b = self.sample(x + stepSize, y)
                c = self.sample(x, y + stepSize)
                d = self.sample(x + halfStep, y + halfStep)
                e = self.sample(x + halfStep, y - halfStep)
                f = self.sample(x - halfStep, y + halfStep)

                H = (a + b + d + e) / 4.0 + (rnd * 2 - 1) * stepSize * scale * 0.5
                g = (a + c + d + f) / 4.0 + (rnd * 2 - 1) * stepSize * scale * 0.5
                self.setSample(x + halfStep, y, H)
                self.setSample(x, y + halfStep, g)
            end for
        end for
        // print "  stepSize{0}:{1}".fill([stepSize, time-startTime]);startTime=time
        
        stepSize /= 2
        scale *= (scaleMod + 0.8)
        scaleMod *= 0.3
    end while

    return self
end function

// @param {int} x
// @param {int} y
// @returns {int}
LevelGen.sample = function(x, y)
    offset = (x + y * self.w) % self.values.len
    return self.values[offset]
end function

// @param {int} x
// @param {int} y
// @param {double} value
LevelGen.setSample = function(x, y, value)
    offset = (x + y * self.w) % self.values.len
    self.values[offset] = value
end function

// @param {int} w
// @param {int} h
// @returns {byte[][]}
LevelGen.createAndValidateTopMap = function(w, h)
    // startTime = time
    // attempt = 0
    while true
        // print "Attempt #{0}, {1}(s)".fill([attempt, time - startTime])
        // attempt += 1
        // startTime = time

        result = self.createTopMap(w, h)

        count = [0] * 256

        for i in range(0, w * h - 1)
            count[result[0][i]] += 1
        end for
        if count[Tile.rock.id] < 100 then
            print "Not enough rock: {0}".fill([count[Tile.rock.id]])
            continue
        end if
        if count[Tile.sand.id] < 100 then
            print "Not enough sand: {0}".fill([count[Tile.sand.id]])
            continue
        end if
        if count[Tile.grass.id] < 100 then
            print "Not enough grass: {0}".fill([count[Tile.grass.id]])
            continue
        end if
        if count[Tile.tree.id] < 100 then
            print "Not enough tree: {0}".fill([count[Tile.tree.id]])
            continue
        end if
        if count[Tile.stairsDown.id] < 2 then
            print "Not enough stairsDown: {0}".fill([count[Tile.stairsDown.id]])
            continue
        end if

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
        attempt += 1
        print "Attempt #" + attempt

        result = self.createUndergroundMap(w, h, depth)
        
        count = [0] * 256

        for i in range(w * h - 1)
            count[result[0][i]] += 1
        end for
        if count[Tile.rock.id] < 100 then
            print "Not enough rock: {0}".fill([count[Tile.rock.id]])
            continue
        end if
        if count[Tile.dirt.id] < 100 then
            print "Not enough dirt: {0}".fill([count[Tile.dirt.id]])
            // continue
        end if
        if count[Tile.ironOre.id + depth - 1] < 20 then
            print "Not enough ore: {0}".fill([count[Tile.ironOre.id + depth - 1]])
            continue
        end if
        if depth < 3 then
            if count[Tile.stairsDown.id] < 2 then
                print "Not enough stairsDown: {0}".fill([count[Tile.stairsDown.id]])
                continue
            end if
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
        attempt += 1
        print "Attempt #" + attempt

        result = self.createSkyMap(w, h)
        
        count = [0] * 256

        for i in range(w * h - 1)
            count[result[0][i]] += 1
        end for
        if count[Tile.cloud.id] < 2000 then continue
        if count[Tile.stairsDown.id] < 2 then continue

        return result
    end while
end function

// @param {int} w
// @param {int} h
// @returns {byte[][]}
LevelGen.createTopMap = function(w, h)
    // startTime = time

    mnoise1 = (new LevelGen).make(w, h, 16)
    noise1 = (new LevelGen).make(w, h, 32)

    map = [0] * w * h
    data = [0] * w * h
    for y in range(0, h - 1)
        for x in range(0, w - 1)
            i = x + y * w
            
            val = abs(noise1.values[i]) * 3 - 2
            mval = abs(mnoise1.values[i]) * 3 - 2

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
            else if (val >= -0.5 and val <= -0.2) or mval > 0.55 then
                map[i] = Tile.sand.id
            else if val > 0.5 and mval < -1.5 then
                map[i] = Tile.rock.id
            else if mval < -1 and val > 0 and val < 0.5 then
                map[i] = Tile.tree.id
            else
                map[i] = Tile.grass.id
            end if
        end for
    end for
    // print "loop0:{0}".fill([time-startTime]);startTime=time

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
    // print "loop3:{0}".fill([time-startTime]);startTime=time

    for i in range(w * h / 100 - 1)
        xx = Random.nextInt(w)
        yy = Random.nextInt(h)
        if map[xx + yy * w] == Tile.sand.id then
            map[xx + yy * w] = Tile.cactus.id
        end if
    end for

    count = 0
    for i in range(w * h / 100)
        x = Random.nextInt(w - 2) + 1
        y = Random.nextInt(h - 2) + 1

        rockCount = 0
        for yy in range(y - 1, y + 1)
            for xx in range(x - 1, x + 1)
                if map[xx + yy * w] != Tile.rock.id then
                    rockCount += 1
                end if
            end for
        end for

        if rockCount > 6 then
            map[x + y * w] = Tile.stairsDown.id
            count += 1
            if count == 4 then break
        end if
    end for

    return [ map, data ]
end function

// @param {int} w
// @param {int} h
// @param {int} depth
// @returns {byte[][]}
LevelGen.createUndergroundMap = function(w, h, depth)
    mnoise1 = (new LevelGen).make(w, h, 16)
    // mnoise2 = (new LevelGen).make(w, h, 16)
    // mnoise3 = (new LevelGen).make(w, h, 16)

    // nnoise1 = (new LevelGen).make(w, h, 16)
    // nnoise2 = (new LevelGen).make(w, h, 16)
    // nnoise3 = (new LevelGen).make(w, h, 16)

    // wnoise1 = (new LevelGen).make(w, h, 16)
    // wnoise2 = (new LevelGen).make(w, h, 16)
    // wnoise3 = (new LevelGen).make(w, h, 16)

    noise1 = (new LevelGen).make(w, h, 32)
    // noise2 = (new LevelGen).make(w, h, 32)

    map = [0] * w * h
    data = [0] * w * h
    for y in range(0, h - 1)
        for x in range(0, w - 1)
            i = x + y * w

            // val = abs(noise1.values[i] - noise2.values[i]) * 3 - 2
            val = abs(noise1.values[i]) * 3 - 2

            // mval = abs(mnoise1.values[i] - mnoise2.values[i])
            // mval = abs(mval - mnoise3.values[i]) * 3 - 2
            mval = abs(mnoise1.values[i]) * 3 - 2

            // nval = abs(nnoise1.values[i] - nnoise2.values[i])
            // nval = abs(nval - nnoise3.values[i]) * 3 - 2
            // nval = abs(nnoise1.values[i]) * 3 - 2
            nval = mval

            wval = abs(nval - mnoise1.values[i]) * 3 - 2
            // wval = abs(nval - wnoise3.values[i]) * 3 - 2
            // wval = abs(wnoise1.values[i]) * 3 - 2

            xd = abs(x / (w - 1.0) * 2 - 1)
            yd = abs(y / (h - 1.0) * 2 - 1)
            if xd >= yd then
                dist = xd
            else
                dist = yd
            end if
            dist = dist ^ 8
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
    for i in range(w * h / 400)
        x = Random.nextInt(w)
        y = Random.nextInt(h)
        for j in range(0, 30)
            xx = x + Random.nextInt(5) - Random.nextInt(5)
            yy = y + Random.nextInt(5) - Random.nextInt(5)
            if xx >= r and yy >= r and xx < w - r and yy < h - r then
                if map[xx + yy * w] == Tile.rock.id then
                    map[xx + yy * w] = Tile.ironOre.id + depth - 1
                end if
            end if
        end for
    end for

    if depth < 3 then
        count = 0
        for i in range(w * h / 100 - 1)
            x = Random.nextInt(w - 2) + 1
            y = Random.nextInt(h - 2) + 1

            rockCount = 0
            for yy in range(y - 1, y + 1)
                for xx in range(x - 1, x + 1)
                    if map[xx + yy * w] == Tile.rock.id then
                        rockCount += 1
                    end if
                end for
            end for

            if rockCount > 6 then
                map[x + y * w] = Tile.stairsDown.id
                count += 1
                if count == 4 then break
            end if
        end for
    end if

    return [ map, data ]
end function

// @param {int} w
// @param {int} h
// @returns {byte[][]}
LevelGen.createSkyMap = function(w, h)
    noise1 = (new LevelGen).make(w, h, 8)
    // noise2 = (new LevelGen).make(w, h, 8)

    map = [0] * w * h
    data = [0] * w * h
    for y in range(0, h - 1)
        for x in range(0, w - 1)
            i = x + y * w

            // val = abs(noise1.values[i] - noise2.values[i]) * 3 - 2
            val = abs(noise1.values[i]) * 3 - 2

            xd = x / (w - 1.0) * 2 - 1
            yd = y / (h - 1.0) * 2 - 1
            if xd < 0 then xd = -xd
            if yd < 0 then yd = -yd
            if xd >= yd then
                dist = xd
            else
                dist = yd
            end if
            dist = dist ^ 8
            val = -val * 1 - 2.2
            val = val + 1 - dist * 20

            if val < -0.25 then
                map[i] = Tile.infiniteFall.id
            else
                map[i] = Tile.cloud.id
            end if
        end for
    end for

    for i in range(0, w * h / 50)
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

        cloudCount = 0
        for yy in range(y - 1, y + 1)
            for xx in range(x - 1, x + 1)
                if map[xx + yy * w] == Tile.cloud.id then
                    cloudCount += 1
                end if
            end for
        end for

        if cloudCount >= 9 then
            map[x + y * w] = Tile.stairsDown.id
            count += 1
            if count == 2 then break
        end if
    end for

    return [ map, data ]
end function

return LevelGen
