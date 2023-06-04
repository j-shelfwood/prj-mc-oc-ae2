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

-- Custom function to draw battery bar
local function drawBatteryBar(energyPercent)
    local barLength = w - 2
    local filledBarLength = math.floor(barLength * energyPercent / 100)
    gpu.fill(1, h / 2, filledBarLength, 1, '=')
    gpu.fill(filledBarLength + 1, h / 2, barLength - filledBarLength, 1, ' ')
end

-- Update the energy status every 0.5 seconds
while true do
    -- Clear the screen for each update
    gpu.fill(1, 1, w, h, ' ')

    -- Get the current energy in RF and EU
    local currentEnergyRF = computer.energy()
    local currentEnergyEU = currentEnergyRF / 4 -- Convert to EU

    -- Get the maximum energy in RF and EU
    local maxEnergyRF = computer.maxEnergy()
    local maxEnergyEU = maxEnergyRF / 4 -- Convert to EU

    -- Calculate the percentage of energy remaining
    local energyPercent = (currentEnergyRF / maxEnergyRF) * 100

    -- Draw the battery bar
    drawBatteryBar(energyPercent)

    -- Print the current and max energy levels, and the energy rate
    gpu.set(1, h / 3,
        "Current Energy: " .. currentEnergyRF .. " RF / " .. string.format("%.2f", currentEnergyEU) .. " EU")
    gpu.set(w, h / 3, "Max Energy: " .. maxEnergyRF .. " RF / " .. string.format("%.2f", maxEnergyEU) .. " EU")
    gpu.set(w, h, "RF/T: " .. string.format("%.2f", currentEnergyRF / 20))

    -- Sleep for 0.5 seconds before the next update
    os.sleep(0.5)
end
