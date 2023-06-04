-- Load the required libraries
local component = require("component")
local computer = require("computer")
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

-- Get the screen address and bind the GPU to it
gpu.bind(screenAddresses[screenNumber])

-- Get screen resolution
local w, h = gpu.getResolution()

-- Set font size
gpu.setResolution(w / 6, h / 6)

-- Custom print function
local function printScreen(text)
    gpu.fill(1, 1, w, h, ' ') -- Clear screen
    gpu.set(1, 1, text)       -- Reset cursor position and print
end

-- Update the energy status every 0.5 seconds
while true do
    -- Clear the screen for each update
    gpu.fill(1, 1, w, h, ' ')

    -- Get and print the current energy in RF and EU
    local currentEnergyRF = computer.energy()
    local currentEnergyEU = currentEnergyRF / 4 -- Convert to EU
    printScreen("Current Energy: " .. currentEnergyRF .. " RF / " .. string.format("%.2f", currentEnergyEU) .. " EU")

    -- Get and print the maximum energy in RF and EU
    local maxEnergyRF = computer.maxEnergy()
    local maxEnergyEU = maxEnergyRF / 4 -- Convert to EU
    printScreen("Max Energy: " .. maxEnergyRF .. " RF / " .. string.format("%.2f", maxEnergyEU) .. " EU")

    -- Calculate and print the percentage of energy remaining
    local energyPercent = (currentEnergyRF / maxEnergyRF) * 100
    printScreen("Energy Remaining: " .. string.format("%.2f", energyPercent) .. "%")

    -- Sleep for 0.5 seconds before the next update
    os.sleep(0.5)
end
