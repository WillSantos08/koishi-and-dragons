local Players = game:GetService("Players")

local GMDashboard = {}

-- Helper genérico para evitar cadeias de WaitForChild
local function waitForPath(root: Instance, path: {string}): Instance?
    local current = root
    for _, name in ipairs(path) do
        current = current:WaitForChild(name, 5)
        if not current then return nil end
    end
    return current
end

local function getInterface(): Instance?
    local player = Players.LocalPlayer
    return waitForPath(player, {
        "PlayerGui",
        "MasterUI",
        "MasterDashboard",
    })
end

local function getButton(): Instance?
    local player = Players.LocalPlayer
    return waitForPath(player, {
        "PlayerGui",
        "GeneralUI",
        "ButtonsContainer",
        "MasterSide",
        "DashboardButton",
    })
end

local visible = false

function GMDashboard:Init()
    local interface = getInterface()
    local button = getButton()
    if not interface or not button then return end

    -- Botão de fechar dentro da interface
    local closeButton = waitForPath(interface, {
        "Debug",
        "Header",
        "RightSide",
        "CloseButton",
    })

    -- Conecta o evento de clique do botão de fechar, se ele existir
    if closeButton then
        closeButton.MouseButton1Click:Connect(function()
            visible = false
            interface.Visible = false
        end)
    end

    -- Botão principal abre/fecha interface
    button.MouseButton1Click:Connect(function()
        visible = not visible
        interface.Visible = visible
    end)
end

return GMDashboard