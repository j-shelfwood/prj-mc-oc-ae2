-- Load the required libraries
local component = require("component")
local computer = require("computer")
local term = require("term")
local shell = require("shell")
local gpu = component.gpu

-- Get a table of all screens
local screens = component.list("screen")

-- Create a list of screen addresses
local screenAddresses = {}
for address in screens do
    table.insert(screenAddresses, address)
end

-- Ask the user to select a screen
print("Please select a screen:")
local originalScreen = gpu.getScreen()
for i, address in ipairs(screenAddresses) do
    gpu.bind(address)
    local w, h = gpu.getResolution()
    print(i .. ": " .. address .. " (" .. w .. "x" .. h .. ")")
end
gpu.bind(originalScreen) -- Reset the binding to the original screen
print("Enter the number of the screen you want to use:")
local screenNumber = tonumber(io.read())

-- Get the screen address and create a proxy
local screen = component.proxy(screenAddresses[screenNumber])

-- Get primary GPU and bind it to the selected screen
local gpu = component.gpu
gpu.bind(screenAddresses[screenNumber])

-- Get screen resolution
local w, h = gpu.getResolution()

-- Initialize cursor position
local cursorX, cursorY = 1, 1

-- Custom print function
local function printScreen(text)
    if cursorY > h then
        gpu.fill(1, 1, w, h, ' ') -- Clear screen
        cursorX, cursorY = 1, 1   -- Reset cursor position
    end
    gpu.set(cursorX, cursorY, text)
    cursorY = cursorY + 1 -- Move cursor to next line
end

-- Update the energy status every 0.5 seconds
while true do
    -- Get and print the current energy
    local currentEnergy = computer.energy()
    printScreen("Current Energy: " .. currentEnergy)

    -- Get and print the maximum energy
    local maxEnergy = computer.maxEnergy()
    printScreen("Max Energy: " .. maxEnergy)

    -- Calculate and print the percentage of energy remaining
    local energyPercent = (currentEnergy / maxEnergy) * 100
    printScreen("Energy Remaining: " .. energyPercent .. "%")

    -- Sleep for 0.5 seconds before the next update
    os.sleep(0.5)
end
