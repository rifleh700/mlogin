local ACCOUNT_FILE_PATH = "@account"
local TOKEN_FILE_PATH = "@token"
local FILE_SIZE_MAX = 4096

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local mloginData = {}

mloginData.accountName = nil


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function fileReadAll(path)

    if not fileExists(path) then return nil end

    local file = fileOpen(path)
    if not file then return nil end

    local size = fileGetSize(file)
    if size >= FILE_SIZE_MAX then
        fileClose(file)
        return nil
    end

    local data = fileRead(file, size)
    fileClose(file)

    if data == "" then return nil end

    return data
end

local function fileWriteAll(path, data)

    local file = fileCreate(path)
    if not file then return false end

    if data then
        fileWrite(file, data)
    end

    fileClose(file)

    return true
end

function requestGuest()

    showLoginMessage()
    setLoginEnabled(false)
    triggerServerEvent("mlogin.requestGuest", localPlayer)
end

function requestLogin(accountName, accountPassword)

    if (not accountName) or accountName == "" then
        showLoginMessage(TEXT.NAME_IS_EMPTY)
        return false
    end

    if (not accountPassword) or accountPassword == "" then
        showLoginMessage(TEXT.PASSWORD_IS_EMPTY)
        return false
    end

    showLoginMessage()
    setLoginEnabled(false)
    triggerServerEvent("mlogin.requestLogin", localPlayer, accountName, accountPassword, mloginData.token, isRememberMeEnabled())
end

addEvent("mlogin.requestLogin.response", true)
addEventHandler("mlogin.requestLogin.response", localPlayer,
    function(status, accountName, attemptsLeft, token)

        if status == STATUS_CODE.OK or status == STATUS_CODE.ALREADY_LOGGED_IN_CURRENT_ACCOUNT then
            showLoginMessage(TEXT.SUCCESSFUL_LOGIN, true)
            hide()
            mloginData.accountName = accountName
            mloginData.token = token

            if token or (not isRememberMeEnabled()) then
                fileWriteAll(ACCOUNT_FILE_PATH, isRememberMeEnabled() and accountName or nil)
                fileWriteAll(TOKEN_FILE_PATH, isRememberMeEnabled() and token or nil)
            end

            return
        end

        if status == STATUS_CODE.ALREADY_LOGGED_IN then
            hide()
            return
        end

        showLoginMessage((TEXT[status] or status) .. (attemptsLeft and string.format(TEXT.ATTEMPTS_LEFT, attemptsLeft) or ""))
        setLoginEnabled(true)

    end
)

function requestRegister(accountName, accountPassword, accountRepeatPassword)

    local status = validateAccountNamePassword(accountName, accountPassword, accountRepeatPassword)
    if status ~= STATUS_CODE.OK then
        showRegisterMessage(TEXT[status] or status)
        return false
    end

    showRegisterMessage()
    setRegisterEnabled(false)
    triggerServerEvent("mlogin.requestRegister", localPlayer, accountName, accountPassword, accountRepeatPassword)
end

addEvent("mlogin.requestRegister.response", true)
addEventHandler("mlogin.requestRegister.response", localPlayer,
    function(status, accountName)

        if status == STATUS_CODE.OK then
            showLogin(accountName)
            showLoginMessage(TEXT.ACCOUNT_REGISTERED, true)
            return
        end

        if status == STATUS_CODE.ALREADY_LOGGED_IN then
            hide()
            return
        end

        showRegisterMessage(TEXT[status] or status)
        setRegisterEnabled(true)

    end
)


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function init()

    mloginData.accountName = fileReadAll(ACCOUNT_FILE_PATH)
    mloginData.token = fileReadAll(TOKEN_FILE_PATH)

end

addEventHandler("onClientResourceStart", resourceRoot, init)

addEvent("mlogin.showPanel", true)
addEventHandler("mlogin.showPanel", localPlayer,
    function()
        showLogin(mloginData.accountName, mloginData.token)
    end
)