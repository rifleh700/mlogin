local SCREEN_WIDTH, SCREEN_HEIGHT = guiGetScreenSize()

local SOUND_ENABLED = true
local SUCCESS_SOUND_ID = 7
local FAIL_SOUND_ID = 4

local WINDOW_WIDTH = SCREEN_HEIGHT / 2
local MARGIN = 10
local ROW_HEIGHT = 30
local CHECK_HEIGHT = 15
local EDIT_WIDTH = (WINDOW_WIDTH - MARGIN * 3) * 3 / 4
local LABEL_WIDTH = (WINDOW_WIDTH - MARGIN * 3) * 1 / 4
local BUTTON_HEIGHT = ROW_HEIGHT
local MESSAGE_COLOR_FAILED = { 255, 127, 127 }
local MESSAGE_COLOR_SUCCESS = { 127, 255, 127 }

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

local gui = {}

gui.login = {}
gui.register = {}

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

local function guiCenter(element)

    local w, h = guiGetSize(element, false)
    local pw, ph = SCREEN_WIDTH, SCREEN_HEIGHT

    local parent = getElementParent(element)
    if parent ~= guiRoot then
        pw, ph = guiGetSize(parent, false)
    end

    local x, y = (pw - w) / 2, (ph - h) / 2

    return guiSetPosition(element, x, y, false)
end

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

local function acceptGuest()

    requestGuest()
end

local function acceptLogin()

    requestLogin(guiGetText(gui.login.nameEdit), guiGetText(gui.login.passEdit))
end

local function acceptRegister()

    requestRegister(guiGetText(gui.register.nameEdit), guiGetText(gui.register.passEdit), guiGetText(gui.register.repeatPassEdit))
end

local function initLogin()

    gui.login.window = guiCreateWindow(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, TEXT.LOGIN, false)
    guiWindowSetSizable(gui.login.window, false)
    guiWindowSetMovable(gui.login.window, false)
    guiSetVisible(gui.login.window, false)
    guiSetEnabled(gui.login.window, false)

    local x = MARGIN
    local y = 20 + MARGIN

    gui.login.nameLabel = guiCreateLabel(x, y, LABEL_WIDTH, ROW_HEIGHT, TEXT.NAME, false, gui.login.window)
    guiLabelSetVerticalAlign(gui.login.nameLabel, "center")
    guiLabelSetHorizontalAlign(gui.login.nameLabel, "right")
    x = x + LABEL_WIDTH + MARGIN
    gui.login.nameEdit = guiCreateEdit(x, y, EDIT_WIDTH, ROW_HEIGHT, "", false, gui.login.window)
    guiEditSetMaxLength(gui.login.nameEdit, 60)
    x = MARGIN
    y = y + ROW_HEIGHT + MARGIN

    gui.login.passLabel = guiCreateLabel(x, y, LABEL_WIDTH, ROW_HEIGHT, TEXT.PASSWORD, false, gui.login.window)
    guiLabelSetVerticalAlign(gui.login.passLabel, "center")
    guiLabelSetHorizontalAlign(gui.login.passLabel, "right")
    x = x + LABEL_WIDTH + MARGIN
    gui.login.passEdit = guiCreateEdit(x, y, EDIT_WIDTH, ROW_HEIGHT, "", false, gui.login.window)
    guiEditSetMasked(gui.login.passEdit, true)
    guiEditSetMaxLength(gui.login.passEdit, 2048)
    y = y + ROW_HEIGHT + MARGIN

    if LOGIN_REMEMBER_ME then
        gui.login.rememberCheck = guiCreateCheckBox(x, y, CHECK_HEIGHT, CHECK_HEIGHT, "", true, false, gui.login.window)
        gui.login.rememberLabel = guiCreateLabel(x + CHECK_HEIGHT + MARGIN, y, EDIT_WIDTH - CHECK_HEIGHT - MARGIN, CHECK_HEIGHT, TEXT.REMEMBER_ME, false, gui.login.window)
        guiLabelSetVerticalAlign(gui.login.rememberLabel, "center")
        y = y + CHECK_HEIGHT + MARGIN
    end

    gui.login.messageLabel = guiCreateLabel(x, y, EDIT_WIDTH, CHECK_HEIGHT, "", false, gui.login.window)
    guiLabelSetVerticalAlign(gui.login.messageLabel, "center")
    guiLabelSetColor(gui.login.messageLabel, MESSAGE_COLOR_SUCCESS[1], MESSAGE_COLOR_SUCCESS[2], MESSAGE_COLOR_SUCCESS[3])
    x = MARGIN
    y = y + CHECK_HEIGHT + MARGIN

    gui.login.registerButton = guiCreateButton(x, y, LABEL_WIDTH, BUTTON_HEIGHT, TEXT.REGISTER, false, gui.login.window)
    x = x + MARGIN + LABEL_WIDTH
    gui.login.acceptButton = guiCreateButton(x, y, EDIT_WIDTH, BUTTON_HEIGHT, TEXT.LOGIN, false, gui.login.window)

    if LOGIN_GUEST then
        local w = EDIT_WIDTH - LABEL_WIDTH - MARGIN
        guiSetSize(gui.login.acceptButton, w, BUTTON_HEIGHT, false)
        gui.login.guestButton = guiCreateButton(x + w + MARGIN, y, LABEL_WIDTH, BUTTON_HEIGHT, TEXT.GUEST, false, gui.login.window)
        addEventHandler("onClientGUIClick", gui.login.guestButton, acceptGuest, false)
    end

    y = y + BUTTON_HEIGHT + MARGIN

    guiSetSize(gui.login.window, WINDOW_WIDTH, y, false)
    guiCenter(gui.login.window)

    addEventHandler("onClientGUIClick", gui.login.acceptButton, acceptLogin, false)
    addEventHandler("onClientGUIClick", gui.login.registerButton, function() showRegister() end, false)
    addEventHandler("onClientGUIAccepted", gui.login.nameEdit, acceptLogin)
    addEventHandler("onClientGUIAccepted", gui.login.passEdit, acceptLogin)

    return true
end

local function initRegister()

    gui.register.window = guiCreateWindow(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, TEXT.REGISTER, false)
    guiWindowSetSizable(gui.register.window, false)
    guiWindowSetMovable(gui.register.window, false)
    guiSetVisible(gui.register.window, false)
    guiSetEnabled(gui.register.window, false)

    local x = MARGIN
    local y = 20 + MARGIN

    gui.register.nameLabel = guiCreateLabel(x, y, LABEL_WIDTH, ROW_HEIGHT, TEXT.NAME, false, gui.register.window)
    guiLabelSetVerticalAlign(gui.register.nameLabel, "center")
    guiLabelSetHorizontalAlign(gui.register.nameLabel, "right")
    x = x + LABEL_WIDTH + MARGIN
    gui.register.nameEdit = guiCreateEdit(x, y, EDIT_WIDTH, ROW_HEIGHT, "", false, gui.register.window)
    guiEditSetMaxLength(gui.register.nameEdit, 1024)
    x = MARGIN
    y = y + ROW_HEIGHT + MARGIN

    gui.register.passLabel = guiCreateLabel(x, y, LABEL_WIDTH, ROW_HEIGHT, TEXT.PASSWORD, false, gui.register.window)
    guiLabelSetVerticalAlign(gui.register.passLabel, "center")
    guiLabelSetHorizontalAlign(gui.register.passLabel, "right")
    x = x + LABEL_WIDTH + MARGIN
    gui.register.passEdit = guiCreateEdit(x, y, EDIT_WIDTH, ROW_HEIGHT, "", false, gui.register.window)
    guiEditSetMasked(gui.register.passEdit, true)
    guiEditSetMaxLength(gui.register.passEdit, 1024)
    x = MARGIN
    y = y + ROW_HEIGHT + MARGIN

    gui.register.repeatPassLabel = guiCreateLabel(x, y, LABEL_WIDTH, ROW_HEIGHT, TEXT.REPEAT_PASSWORD, false, gui.register.window)
    guiLabelSetVerticalAlign(gui.register.repeatPassLabel, "center")
    guiLabelSetHorizontalAlign(gui.register.repeatPassLabel, "right")
    x = x + LABEL_WIDTH + MARGIN
    gui.register.repeatPassEdit = guiCreateEdit(x, y, EDIT_WIDTH, ROW_HEIGHT, "", false, gui.register.window)
    guiEditSetMasked(gui.register.repeatPassEdit, true)
    guiEditSetMaxLength(gui.register.repeatPassEdit, 1024)
    y = y + ROW_HEIGHT + MARGIN

    gui.register.messageLabel = guiCreateLabel(x, y, EDIT_WIDTH, CHECK_HEIGHT, "", false, gui.register.window)
    guiLabelSetVerticalAlign(gui.register.messageLabel, "center")
    guiLabelSetColor(gui.register.messageLabel, MESSAGE_COLOR_SUCCESS[1], MESSAGE_COLOR_SUCCESS[2], MESSAGE_COLOR_SUCCESS[3])
    x = MARGIN
    y = y + CHECK_HEIGHT + MARGIN

    gui.register.loginButton = guiCreateButton(x, y, LABEL_WIDTH, BUTTON_HEIGHT, TEXT.LOGIN, false, gui.register.window)
    x = x + MARGIN + LABEL_WIDTH
    gui.register.acceptButton = guiCreateButton(x, y, EDIT_WIDTH, BUTTON_HEIGHT, TEXT.REGISTER, false, gui.register.window)
    y = y + BUTTON_HEIGHT + MARGIN

    guiSetSize(gui.register.window, WINDOW_WIDTH, y, false)
    guiCenter(gui.register.window)

    addEventHandler("onClientGUIClick", gui.register.acceptButton, acceptRegister, false)
    addEventHandler("onClientGUIClick", gui.register.loginButton, function() showLogin(guiGetText(gui.login.nameEdit), isRememberMeEnabled()) end, false)
    addEventHandler("onClientGUIAccepted", gui.register.nameEdit, acceptRegister)
    addEventHandler("onClientGUIAccepted", gui.register.passEdit, acceptRegister)
    addEventHandler("onClientGUIAccepted", gui.register.repeatPassEdit, acceptRegister)

    return true
end

local function init()

    initLogin()
    initRegister()

    return true
end

addEventHandler("onClientResourceStart", resourceRoot, init)

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function showLogin(name, auto)

    guiSetVisible(gui.register.window, false)
    guiSetEnabled(gui.register.window, false)

    guiSetVisible(gui.login.window, true)
    guiSetEnabled(gui.login.window, true)
    guiBringToFront(gui.login.window)
    showCursor(true)

    if name then guiSetText(gui.login.nameEdit, name) end
    guiSetText(gui.login.passEdit, "")

    if name and auto then
        guiSetText(gui.login.passEdit, LOGIN_REMEMBER_ME_PASSWORD)
    end

    showLoginMessage()

    return true
end

function setLoginEnabled(enabled)

    return guiSetEnabled(gui.login.window, enabled and true or false)
end

function showRegister(name)

    guiSetVisible(gui.login.window, false)
    guiSetEnabled(gui.login.window, false)

    guiSetVisible(gui.register.window, true)
    guiSetEnabled(gui.register.window, true)
    guiBringToFront(gui.register.window)
    showCursor(true)

    if name then guiSetText(gui.register.nameEdit, name) end
    guiSetText(gui.register.passEdit, "")
    guiSetText(gui.register.repeatPassEdit, "")

    showRegisterMessage()

    return true
end

function setRegisterEnabled(enabled)

    return guiSetEnabled(gui.register.window, enabled and true or false)
end

function showLoginMessage(message, success)

    if message and SOUND_ENABLED then
        playSoundFrontEnd(success and SUCCESS_SOUND_ID or FAIL_SOUND_ID)
    end

    if success then
        guiLabelSetColor(gui.login.messageLabel, MESSAGE_COLOR_SUCCESS[1], MESSAGE_COLOR_SUCCESS[2], MESSAGE_COLOR_SUCCESS[3])
    else
        guiLabelSetColor(gui.login.messageLabel, MESSAGE_COLOR_FAILED[1], MESSAGE_COLOR_FAILED[2], MESSAGE_COLOR_FAILED[3])
    end

    return guiSetText(gui.login.messageLabel, message or "")
end

function showRegisterMessage(message, success)

    if message and SOUND_ENABLED then
        playSoundFrontEnd(success and SUCCESS_SOUND_ID or FAIL_SOUND_ID)
    end

    if success then
        guiLabelSetColor(gui.register.messageLabel, MESSAGE_COLOR_SUCCESS[1], MESSAGE_COLOR_SUCCESS[2], MESSAGE_COLOR_SUCCESS[3])
    else
        guiLabelSetColor(gui.register.messageLabel, MESSAGE_COLOR_FAILED[1], MESSAGE_COLOR_FAILED[2], MESSAGE_COLOR_FAILED[3])
    end

    return guiSetText(gui.register.messageLabel, message or "")
end

function hide()

    setLoginEnabled()
    setRegisterEnabled()
    guiSetVisible(gui.login.window, false)
    guiSetVisible(gui.register.window, false)
    showCursor(false)

    return true
end

function isRememberMeEnabled()

    return LOGIN_REMEMBER_ME and guiCheckBoxGetSelected(gui.login.rememberCheck)
end
