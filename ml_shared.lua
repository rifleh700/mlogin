-- allow guest
LOGIN_GUEST = false

-- not implemented
LOGIN_REMEMBER_ME = true

-- this is illegal pass so we can use it for autologin
LOGIN_REMEMBER_ME_PASSWORD = "*****"

REGISTER_NAME_LENGTH_MIN = 1
REGISTER_NAME_LENGTH_MAX = 128
REGISTER_PASSWORD_LENGTH_MIN = 4
REGISTER_PASSWORD_LENGTH_MAX = 128

STATUS_CODE = {
    OK = "OK",
    NAME_IS_EMPTY = "NAME_IS_EMPTY",
    NAME_IS_TOO_LONG = "NAME_IS_TOO_LONG",
    NAME_IS_TOO_SHORT = "NAME_IS_TOO_SHORT",
    NAME_IS_NOT_ALLOWED = "NAME_IS_NOT_ALLOWED",
    PASSWORD_IS_EMPTY = "PASSWORD_IS_EMPTY",
    PASSWORD_IS_TOO_LONG = "PASSWORD_IS_TOO_LONG",
    PASSWORD_IS_TOO_SHORT = "PASSWORD_IS_TOO_SHORT",
    PASSWORD_IS_NOT_ALLOWED = "PASSWORD_IS_NOT_ALLOWED",
    PASSWORD_IS_EQUAL_NAME = "PASSWORD_IS_EQUAL_NAME",
    REPEAT_PASSWORD_IS_EMPTY = "REPEAT_PASSWORD_IS_EMPTY",
    REPEAT_PASSWORD_IS_NOT_MATCHED = "REPEAT_PASSWORD_IS_NOT_MATCHED",
    ALREADY_LOGGED_IN = "ALREADY_LOGGED_IN",
    ALREADY_LOGGED_IN_CURRENT_ACCOUNT = "ALREADY_LOGGED_IN_CURRENT_ACCOUNT",
    WRONG_NAME_PASSWORD_PAIR = "WRONG_NAME_PASSWORD_PAIR",
    LAST_SERIAL_DIFFERENT = "LAST_SERIAL_DIFFERENT",
    REGISTER_SERIAL_DIFFERENT = "REGISTER_SERIAL_DIFFERENT",
    ACCOUNT_IS_OCCUPIED = "ACCOUNT_IS_OCCUPIED",
    NAME_ALREADY_EXISTS = "NAME_ALREADY_EXISTS",
    UNKNOWN_ERROR = "UNKNOWN_ERROR"
}

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function validateAccountNamePassword(name, password, repeatPassword)

    if (not name) or name == "" then return STATUS_CODE.NAME_IS_EMPTY end
    if utf8.len(name) > REGISTER_NAME_LENGTH_MAX then return STATUS_CODE.NAME_IS_TOO_LONG end
    if utf8.len(name) < REGISTER_NAME_LENGTH_MIN then return STATUS_CODE.NAME_IS_TOO_SHORT end
    if name == LOGIN_REMEMBER_ME_PASSWORD then return STATUS_CODE.NAME_IS_NOT_ALLOWED end

    if (not password) or password == "" then return STATUS_CODE.PASSWORD_IS_EMPTY end
    if utf8.len(password) > REGISTER_PASSWORD_LENGTH_MAX then return STATUS_CODE.PASSWORD_IS_TOO_LONG end
    if utf8.len(password) < REGISTER_PASSWORD_LENGTH_MIN then return STATUS_CODE.PASSWORD_IS_TOO_SHORT end
    if password == LOGIN_REMEMBER_ME_PASSWORD then return STATUS_CODE.PASSWORD_IS_NOT_ALLOWED end
    if password == name then return STATUS_CODE.PASSWORD_IS_EQUAL_NAME end

    if (not repeatPassword) or repeatPassword == "" then return STATUS_CODE.REPEAT_PASSWORD_IS_EMPTY end
    if repeatPassword ~= password then return STATUS_CODE.REPEAT_PASSWORD_IS_NOT_MATCHED end

    return STATUS_CODE.OK
end