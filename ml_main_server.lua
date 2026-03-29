local LOGIN_WHEN_LOGGED_IN = false
local LOGIN_BLOCK_IF_LAST_SERIAL_DIFFERENT = false
local LOGIN_BLOCK_IF_REGISTER_SERIAL_DIFFERENT = false
local LOGIN_ATTEMPTS_LIMIT = 5
local LOGIN_COMMAND_DISABLED = true
local LOGOUT_COMMAND_DISABLED = true

local REGISTER_WHEN_LOGGED_IN = false
local REGISTER_SAVE_SERIAL = true
local REGISTER_SAVE_SERIAL_ACCOUNT_DATA = "register_serial"
local REGISTER_ATTEMPTS_LIMIT = 10
local REGISTER_COMMAND_DISABLED = true

local FADE_CAMERA = true
local FADE_CAMERA_TIME = 2
local WAITING_FREEZE_PLAYER = true
local WAITING_CAMERA = true
local WAITING_CAMERA_MATRIX = {
    { 2549, -1718, 28, 2478, -1655, 13 }
}


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


-- shared events
addEvent("mlogin.onPlayerLogin", false)
addEvent("mlogin.onPlayerRegistered", false)

local playersData = {}


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

local function outputDebugStringEventSecurity(message)

    local result = "SECURITY: " .. getResourceName() .. ": " .. message

    local data = {}

    if eventName then
        data[#data + 1] = "event_name:" .. eventName
    end

    if sourceResource and getResourceName(sourceResource) then
        data[#data + 1] = "source_resource_name:" .. getResourceName(sourceResource)
    end

    if client and isElement(client) then
        data[#data + 1] = "client_name:" .. getPlayerName(client)
        data[#data + 1] = "client_ip:" .. getPlayerIP(client)
        data[#data + 1] = "client_serial:" .. getPlayerSerial(client)
    end

    result = result .. " (" .. table.concat(data, " ") .. ")"

    return outputDebugString(result, 4, 255, 255, 127);
end

local function checkEventClientTrigger()

    if client and (client ~= source) then
        outputDebugStringEventSecurity("event source does not match with client")
        kickPlayer(client, getResourceName() .. " AC")
        return false
    end

    if not client then
        outputDebugStringEventSecurity("expected client event trigger but client is nil")
        return false
    end

    return true
end

function getAccountSerialNotBlank(account)

    local serial = getAccountSerial(account)

    if not serial then return nil end
    if serial == "" then return nil end
    if serial == " " then return nil end
    return serial
end


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

local function preparePlayer(player)

    if WAITING_FREEZE_PLAYER then
        setElementFrozen(player, true)
    end

    if FADE_CAMERA then
        fadeCamera(player, true, FADE_CAMERA_TIME)
    end

    if WAITING_CAMERA then
        local m = WAITING_CAMERA_MATRIX[math.random(#WAITING_CAMERA_MATRIX)]
        setCameraMatrix(player, m[1], m[2], m[3], m[4], m[5], m[6])
    end

    return true
end

local function finishPlayerLogin(player)

    if WAITING_FREEZE_PLAYER then
        setElementFrozen(player, false)
    end

    return true
end

addEventHandler("onPlayerJoin", root,
    function()
        preparePlayer(source)
    end
)

addEventHandler("onPlayerResourceStart", root,
    function(loadedResource)

        if loadedResource ~= getThisResource() then return end

        local currentAccount = getPlayerAccount(source)
        if not isGuestAccount(currentAccount) then return end

        triggerClientEvent(source, "mlogin.showPanel", source)

    end
)

addEvent("mlogin.requestGuest", true)
addEventHandler("mlogin.requestGuest", root,
    function()

        if not checkEventClientTrigger() then return end
        local player = client

        local currentAccount = getPlayerAccount(player)
        if (not isGuestAccount(currentAccount)) then
            triggerClientEvent(player, "mlogin.requestLogin.response", player, STATUS_CODE.ALREADY_LOGGED_IN)
            return
        end

        if not LOGIN_GUEST then
            triggerClientEvent(player, "mlogin.requestLogin.response", player, STATUS_CODE.UNKNOWN_ERROR)
            return
        end

        triggerClientEvent(player, "mlogin.requestLogin.response", player, STATUS_CODE.OK)
        triggerEvent("mlogin.onPlayerLogin", player, currentAccount)
        finishPlayerLogin(player)

    end
)

addEvent("mlogin.requestLogin", true)
addEventHandler("mlogin.requestLogin", root,
    function(accountName, accountPassword)

        if not checkEventClientTrigger() then return end
        local player = client

        local currentAccount = getPlayerAccount(player)
        if (not LOGIN_WHEN_LOGGED_IN) and (not isGuestAccount(currentAccount)) then
            triggerClientEvent(player, "mlogin.requestLogin.response", player, STATUS_CODE.ALREADY_LOGGED_IN)
            return
        end

        if (not accountName) or accountName == "" then
            triggerClientEvent(player, "mlogin.requestLogin.response", player, STATUS_CODE.NAME_IS_EMPTY)
            return
        end

        if (not accountPassword) or accountPassword == "" then
            triggerClientEvent(player, "mlogin.requestLogin.response", player, STATUS_CODE.PASSWORD_IS_EMPTY)
            return
        end

        if LOGIN_REMEMBER_ME and accountPassword == LOGIN_REMEMBER_ME_PASSWORD then
            -- autologin...
        end

        local account = getAccount(accountName, accountPassword)
        if not account then

            if not playersData[player] then playersData[player] = {} end
            playersData[player].loginAttempts = (playersData[player].loginAttempts or 0) + 1
            local attemptsLeft = LOGIN_ATTEMPTS_LIMIT - playersData[player].loginAttempts

            if attemptsLeft <= 0 then
                kickPlayer(player, TEXT.LOGIN_ATTEMPTS_LIMIT_REACHED)
                return
            end

            triggerClientEvent(player, "mlogin.requestLogin.response", player, STATUS_CODE.WRONG_NAME_PASSWORD_PAIR, accountName, attemptsLeft)
            return
        end

        if LOGIN_WHEN_LOGGED_IN and getAccountName(currentAccount) == accountName then
            triggerClientEvent(player, "mlogin.requestLogin.response", player, STATUS_CODE.ALREADY_LOGGED_IN_CURRENT_ACCOUNT)
            return
        end

        local playerSerial = getPlayerSerial(player)
        local accountLastSerial = getAccountSerialNotBlank(account)

        if accountLastSerial and LOGIN_BLOCK_IF_LAST_SERIAL_DIFFERENT and (playerSerial ~= accountLastSerial) then
            triggerClientEvent(player, "mlogin.requestLogin.response", player, STATUS_CODE.LAST_SERIAL_DIFFERENT)
            return
        end

        if LOGIN_BLOCK_IF_REGISTER_SERIAL_DIFFERENT then
            local accountRegisterSerial = getAccountData(account, REGISTER_SAVE_SERIAL_ACCOUNT_DATA)
            if accountRegisterSerial and accountRegisterSerial ~= playerSerial then
                triggerClientEvent(player, "mlogin.requestLogin.response", player, STATUS_CODE.REGISTER_SERIAL_DIFFERENT)
                return
            end
        end

        local accountPlayer = getAccountPlayer(account)
        if accountPlayer then
            triggerClientEvent(player, "mlogin.requestLogin.response", player, STATUS_CODE.ACCOUNT_IS_OCCUPIED)
            return
        end

        if currentAccount then logOut(player) end
        local login = logIn(player, account, accountPassword)
        if not login then
            triggerClientEvent(player, "mlogin.requestLogin.response", player, STATUS_CODE.UNKNOWN_ERROR)
            return
        end

        triggerClientEvent(player, "mlogin.requestLogin.response", player, STATUS_CODE.OK, accountName)
        triggerEvent("mlogin.onPlayerLogin", player, account)
        finishPlayerLogin(player)

    end
)

addEvent("mlogin.requestRegister", true)
addEventHandler("mlogin.requestRegister", root,
    function(accountName, accountPassword, accountRepeatPassword)

        if not checkEventClientTrigger() then return end
        local player = client

        local currentAccount = getPlayerAccount(player)
        if (not REGISTER_WHEN_LOGGED_IN) and (not isGuestAccount(currentAccount)) then
            triggerClientEvent(player, "mlogin.requestRegister.response", player, STATUS_CODE.ALREADY_LOGGED_IN)
            return
        end

        local status = validateAccountNamePassword(accountName, accountPassword, accountRepeatPassword)
        if status ~= STATUS_CODE.OK then
            triggerClientEvent(player, "mlogin.requestRegister.response", player, status)
            return
        end

        local existedAccount = getAccount(accountName)
        if existedAccount then

            if not playersData[player] then playersData[player] = {} end
            playersData[player].registerAttempts = (playersData[player].registerAttempts or 0) + 1
            local attemptsLeft = REGISTER_ATTEMPTS_LIMIT - playersData[player].registerAttempts

            if attemptsLeft <= 0 then
                kickPlayer(player, TEXT.REGISTER_ATTEMPTS_LIMIT_REACHED)
                return
            end

            triggerClientEvent(player, "mlogin.requestRegister.response", player, STATUS_CODE.NAME_ALREADY_EXISTS)
            return
        end

        local addAccountResult = addAccount(accountName, accountPassword)
        if not addAccountResult then
            triggerClientEvent(player, "mlogin.requestRegister.response", player, STATUS_CODE.UNKNOWN_ERROR)
            return
        end

        if REGISTER_SAVE_SERIAL then
            setAccountData(addAccountResult, REGISTER_SAVE_SERIAL_ACCOUNT_DATA, getPlayerSerial(player))
        end

        triggerClientEvent(player, "mlogin.requestRegister.response", player, STATUS_CODE.OK, accountName)
        triggerEvent("mlogin.onPlayerRegistered", player, addAccountResult)
    end
)

addEventHandler("onPlayerQuit", root,
    function()

        playersData[source] = nil

    end
)

addEventHandler("onPlayerCommand", root,
    function(command)

        if command == "login" then
            if LOGIN_COMMAND_DISABLED then cancelEvent() end
            return
        end

        if command == "logout" then
            if LOGOUT_COMMAND_DISABLED then cancelEvent() end
            return
        end

        if command == "register" then
            if REGISTER_COMMAND_DISABLED then cancelEvent() end
            return
        end

    end,
    true,
    "high")
