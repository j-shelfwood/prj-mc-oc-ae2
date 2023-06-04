-- Load the required libraries
local component = require("component")
local computer = require("computer")
local term = require("term")
local shell = require("shell")

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
    print(i .. ": " .. address)
end
print("Enter the number of the screen you want to use:")
local screenNumber = tonumber(io.read())

-- Get the screen address and create a proxy
local screen = component.proxy(screenAddresses[screenNumber])

-- Set the output to the selected screen
term.redirect(screen)

-- Update the energy status every 0.5 seconds
while true do
    -- Get and print the current energy
    local currentEnergy = computer.energy()
    print("Current Energy: " .. currentEnergy)

    -- Get and print the maximum energy
    local maxEnergy = computer.maxEnergy()
    print("Max Energy: " .. maxEnergy)

    -- Calculate and print the percentage of energy remaining
    local energyPercent = (currentEnergy / maxEnergy) * 100
    print("Energy Remaining: " .. energyPercent .. "%")

    -- Clear the screen for the next update
    term.clear()

    -- Sleep for 0.5 seconds before the next update
    os.sleep(0.5)
end
