# mlogin
Simple MTA:SA login panel

## Features
- Configurable
- Modify-friendly
- Basic security included
- Can be used as a template for your own login panel

## Quick start
Please execute `aclrequest allow mlogin all` command before using. The resource requires the following rights
```xml
    <aclrequest>
        <right name="function.addAccount" access="true"/>
        <right name="function.logIn" access="true"/>
        <right name="function.kickPlayer" access="true"/>
    </aclrequest>
```
> [!NOTE]  
> Resource must be downloaded last, so it has low priority `<download_priority_group>-1000</download_priority_group>`

## Remember me
The resource does not implement "Remember me" feature since it's impossible to keep default `/login` command working at same time (or it will be unsecure implementation).
More info:
- https://forum.multitheftauto.com/topic/112973-handling-user-credentials-authentication/
- https://wiki.multitheftauto.com/wiki/PasswordHash (look example)

However, resource has some stubs for your own implementations. See `LOGIN_REMEMBER_ME` setting.


## Settings
You can configure this resource with predefined global Lua variables (see script files). Some of important settings are below
- `ml_shared.lua` `LOGIN_GUEST` (default value is `false`) allows login as guest
- `ml_main_server.lua` `LOGIN_COMMAND_DISABLED` (default value is `true`) disables `login` command
- `ml_main_server.lua` `LOGOUT_COMMAND_DISABLED` (default value is `true`) disables `logout` command
- `ml_main_server.lua` `REGISTER_COMMAND_DISABLED` (default value is `true`) disables `register` command
- `ml_main_server.lua` `FADE_CAMERA` (default value is `true`) fades in player's camera when player joined
- `ml_main_server.lua` `WAITING_FREEZE_PLAYER` (default value is `true`) freezes player when player joined
- `ml_main_server.lua` `WAITING_CAMERA` (default value is `true`) sets player's camera matrix when player joined
- `ml_main_server.lua` `LOGIN_BLOCK_IF_REGISTER_SERIAL_DIFFERENT` (default value is `false`) blocks login if current and register player's serials are different
- `ml_main_server.lua` `LOGIN_BLOCK_IF_LAST_SERIAL_DIFFERENT` (default value is `false`) blocks login if current and last player's serials are different


## Shared server-side events
- `mlogin.onPlayerLogin` `function(account)`
- `mlogin.onPlayerRegistered` `function(account)`

## Screenshots

![screenshot1](https://i.imgur.com/5w9kTPg.jpeg)
![screenshot2](https://i.imgur.com/rw5J49U.jpeg)