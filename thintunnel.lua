if not turtle then
    printError("Requires a Turtle")
    return
end

local tArgs = { ... }
if #tArgs ~= 1 then
    local programName = arg[0] or fs.getName(shell.getRunningProgram())
    print("Usage: " .. programName .. "length")
    return
end

local length = tonumber(tArgs[1])
if length < 1 then
    print("Length must be positive.")
    return
end

local function refuel()
    local fuelLevel = turtle.getFuelLevel()
    if fuelLevel == "unlimited" or fuelLevel > 0 then
        return
    end

    local function tryRefuel()
        for n = 1, 16 do
            if turtle.getItemCount(n) > 0 then
                turtle.select(n)
                if turtle.refuel(1) then
                    turtle.select(1)
                    return true
                end
            end
        end
        turtle.select(1)
        return false
    end

    if not tryRefuel() then
        print("Add more fuel to continue.")
        while not tryRefuel() do
            os.pullEvent("turtle_inventory")
        end
        print("Resuming.")
    end
end

local function tryDig()
    while turtle.detect() do
        if not turtle.dig() then
            return false
        end
        sleep(0.5)
    end
end

local function tryDigDown()
    while turtle.detectDown() do
        if not turtle.digDown() then
            return false
        end
        sleep(0.5)
    end
end

local function tryDigUp()
    while turtle.detectUp() do
        if not turtle.digUp() then
            return false
        end
        sleep(0.5)
    end
end

local function tryForward()
    refuel()
    while not turtle.forward() do
        if tryDig() or turtle.attack() then
            sleep(0.5)
        else
            return false
        end
    end
    return true
end

local function tryDown()
    refuel()
    while not turtle.down() do
        if tryDigDown() or turtle.attackDown() then
            sleep(0.5)
        else
            return false
        end
    end
    return true
end

for n = 1, length do
    tryDigUp()
    tryDig()
    tryDigDown()
    tryForward()
end
