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

LANGUAGES = {}
LANGUAGES.EN = {
    LOGIN_ATTEMPTS_LIMIT_REACHED = "Login attempts limit has been reached",
    REGISTER_ATTEMPTS_LIMIT_REACHED = "Register attempts limit has been reached",
    LOGIN = "Login",
    GUEST = "Guest",
    REGISTER = "Register",
    NAME = "Name",
    PASSWORD = "Password",
    REPEAT_PASSWORD = "Repeat",
    REMEMBER_ME = "Remember me",
    NAME_IS_EMPTY = "Type account name",
    NAME_IS_TOO_SHORT = "Account name is too short",
    NAME_IS_TOO_LONG = "Account name is too long",
    NAME_IS_NOT_ALLOWED = "This account name is now allowed",
    PASSWORD_IS_EMPTY = "Type password",
    PASSWORD_IS_TOO_LONG = "Password is too long",
    PASSWORD_IS_TOO_SHORT = "Password is too short",
    PASSWORD_IS_NOT_ALLOWED = "This password is now allowed",
    PASSWORD_IS_EQUAL_NAME = "Password cannot be same as name",
    REPEAT_PASSWORD_IS_EMPTY = "Type password repeat",
    REPEAT_PASSWORD_IS_NOT_MATCHED = "Password repeat not matched with password",
    WRONG_NAME_PASSWORD_PAIR = "Wrong name or/and password",
    ATTEMPTS_LEFT = " (attempts left: %d)",
    LAST_SERIAL_DIFFERENT = "Your current serial and last account serial are different",
    REGISTER_SERIAL_DIFFERENT = "Your current serial and registration account serial are different",
    ACCOUNT_IS_OCCUPIED = "This account is already in use",
    NAME_ALREADY_EXISTS = "This account name is already exists",
    ACCOUNT_REGISTERED = "Account registered",
    SUCCESSFUL_LOGIN = "Successful login",
    UNKNOWN_ERROR = "Unknown error"
}

TEXT = LANGUAGES.EN


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