Random = {}
Random.haveNextNextGaussian = false
Random.nextNextGaussian = 0

Random.nextFloat = function
    return rnd
end function

Random.nextInt = function(limit)
    return floor(self.nextFloat * limit)
end function

Random.nextBoolean = function
    if self.nextFloat >= 0.5 then return true
    return false
end function

Random.nextGaussian = function
    if self.haveNextNextGaussian then
        self.haveNextNextGaussian = false
        return self.nextNextGaussian
    else
        s = 0
        while true
            while true
                v1 = 2.0 * self.nextFloat - 1.0
                v2 = 2.0 * self.nextFloat - 1.0
                s = v1 * v1 + v2 * v2

                if s < 1.0 then break
            end while

            if s != 0.0 then break
        end while
        
        multiplier = sqrt(-2 * log(s) / s)
        self.nextNextGaussian = v2 * multiplier
        self.haveNextNextGaussian = true
        return v1 * multiplier;
    end if
end function

return Random
