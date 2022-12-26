if not turtle then
    printError("Requires a Turtle")
    return
end

local tArgs = { ... }
if #tArgs ~= 3 then
    local programName = arg[0] or fs.getName(shell.getRunningProgram())
    print("Usage: " .. programName .. " width length height/3")
    return
end

local width = tonumber(tArgs[1])
local length = tonumber(tArgs[2])
local height = tonumber(tArgs[3])
if length < 1 or width < 1 or height < 1 then
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

local function tryForward()
    refuel()
    while not turtle.forward() do
        if turtle.dig() or turtle.attack() then
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
        if turtle.digDown() or turtle.attackDown() then
            sleep(0.5)
        else
            return false
        end
    end
    return true
end

local function forceMove(fun)
    while not fun() do
        print("Cannot move! Press a key to retry.")
        os.pullEvent("key")
    end
end

local function turn(y, z, w)
    local _y = y % 2 ~= 0
    local _w = w % 2 ~= 0
    local _z = z % 2 ~= 0

    if (not (_w or _z or _y)) or (_y and (_w or _z)) then
        turtle.turnRight()
    else
        turtle.turnLeft()
    end
end

for z = 1, height do
    print("Level " .. z .. "/" .. height)
    for y = 1, width do
        for x = 1, length do
            turtle.digUp()
            turtle.digDown()
            if x ~= length then
                turtle.dig()
                forceMove(tryForward)
            end
        end
        
        if y ~= width then
            turn(y, z, width)
            turtle.dig()
            forceMove(tryForward)
            turn(y, z, width)
        end
    end



    turtle.turnRight()
    turtle.turnRight()

    if z ~= height then
        for i = 1, 3 do
            turtle.digDown()
            forceMove(tryDown)
        end
    end
end