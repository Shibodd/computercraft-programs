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

for n = 1, length do
    turtle.digUp()
    turtle.dig()
    turtle.digDown()
    
    while not tryForward() then
        print("Cannot move! Press a key to retry.")
        os.pullEvent("key")
    end
end
