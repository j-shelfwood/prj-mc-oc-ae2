-- Load the required libraries
local component = require("component")
local computer = require("computer")
local gpu = component.gpu
local buffer = require("doubleBuffering")
local event = require("event")

-- Constants for design
local barChar = "▄"
local barColor = 0x00FF00

-- Get a table of all screens
local screens = component.list("screen")

-- Create a list of screen addresses
local screenAddresses = {}
for address in screens do
    table.insert(screenAddresses, address)
end

-- Ask the user to select a screen
print("Please select a screen:")
for i, address in ipairs(screenAddresses) do
    gpu.bind(address)
    local w, h = gpu.getResolution()
    print(i .. ": " .. address .. " (" .. w .. "x" .. h .. ")")
end
gpu.bind(originalScreen) -- Reset the binding to the original screen
print("Enter the number of the screen you want to use:")
local screenNumber = tonumber(io.read())

-- Get the screen address and bind the GPU to it
gpu.bind(screenAddresses[screenNumber])

-- Get screen resolution
local w, h = gpu.getResolution()

-- Prepare the buffer
buffer.setResolution(w, h)
buffer.clear(0x000000)

local function drawStatusBar(x, y, length, percent, color)
    local fillLength = math.floor(length * percent / 100)
    buffer.square(x, y, fillLength, 1, color, 0xFFFFFF, "")
    buffer.square(x + fillLength, y, length - fillLength, 1, 0x000000, 0xFFFFFF, "")
end

local function drawEnergyStatus()
    -- Get the current energy in RF and EU
    local currentEnergyRF = computer.energy()
    local currentEnergyEU = currentEnergyRF / 4 -- Convert to EU

    -- Get the maximum energy in RF and EU
    local maxEnergyRF = computer.maxEnergy()
    local maxEnergyEU = maxEnergyRF / 4 -- Convert to EU

    -- Calculate the percentage of energy remaining
    local energyPercent = (currentEnergyRF / maxEnergyRF) * 100

    buffer.clear(0x000000)

    -- Print the current and max energy levels
    buffer.text(2, 2, 0xFFFFFF,
        "Current Energy: " .. currentEnergyRF .. " RF / " .. string.format("%.2f", currentEnergyEU) .. " EU")
    buffer.text(2, 3, 0xFFFFFF, "Max Energy: " .. maxEnergyRF .. " RF / " .. string.format("%.2f", maxEnergyEU) .. " EU")

    -- Draw the battery bar
    drawStatusBar(2, 5, w - 2, energyPercent, barColor)

    -- Draw RF/T rate
    buffer.text(w - 10, h, 0xFFFFFF, "RF/T: " .. string.format("%.2f", currentEnergyRF / 20))

    buffer.draw()
end

-- Run the main loop
while true do
    drawEnergyStatus()
    os.sleep(0.5)
end
