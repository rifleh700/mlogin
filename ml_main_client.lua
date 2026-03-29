local ACCOUNT_FILE_PATH = "@account"
local FILE_SIZE_MAX = 4096

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local mloginData = {}

mloginData.accountName = nil


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function loadFileAccount()

    if not fileExists(ACCOUNT_FILE_PATH) then return nil end

    local file = fileOpen(ACCOUNT_FILE_PATH)
    if not file then return nil end

    local size = fileGetSize(file)
    if size >= FILE_SIZE_MAX then
        fileClose(file)
        return nil
    end

    local name = fileRead(file, size)
    fileClose(file)

    if name == "" then return nil end

    return name
end

local function saveFileAccount(name)

    local file = fileCreate(ACCOUNT_FILE_PATH)
    if not file then return false end

    if name then
        fileWrite(file, name)
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
    triggerServerEvent("mlogin.requestLogin", localPlayer, accountName, accountPassword)
end

addEvent("mlogin.requestLogin.response", true)
addEventHandler("mlogin.requestLogin.response", localPlayer,
    function(status, accountName, attemptsLeft)

        if status == STATUS_CODE.OK or status == STATUS_CODE.ALREADY_LOGGED_IN_CURRENT_ACCOUNT then
            showLoginMessage(TEXT.SUCCESSFUL_LOGIN, true)
            hide()
            mloginData.accountName = accountName
            saveFileAccount(LOGIN_REMEMBER_ME and isRememberMeEnabled() and accountName or nil)
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

    mloginData.accountName = loadFileAccount()

end

addEventHandler("onClientResourceStart", resourceRoot, init)

addEvent("mlogin.showPanel", true)
addEventHandler("mlogin.showPanel", localPlayer,
    function()
        showLogin(mloginData.accountName)
    end
)