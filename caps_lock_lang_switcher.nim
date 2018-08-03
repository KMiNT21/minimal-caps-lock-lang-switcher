# Minimal Language Layout Switcher
# Building: nim c --app:gui caps_lock_lang_switcher.nim 
import winim

proc HookCallback(nCode: int32, wParam: WPARAM, lParam: LPARAM): LRESULT {.stdcall.} =
    if nCode == HC_ACTION and wParam == WM_KEYDOWN:
        var kbdstruct: PKBDLLHOOKSTRUCT = cast[ptr KBDLLHOOKSTRUCT](lparam)
        if byte(kbdstruct.vkCode) == VK_CAPITAL:
            PostMessage(GetForegroundWindow(), WM_INPUTLANGCHANGEREQUEST, 2, 0)
            return 1 # filter this key
    return CallNextHookEx(0, nCode, wParam, lParam)

SetWindowsHookEx(WH_KEYBOARD_LL, (HOOKPROC) HookCallback, 0,  0)
PostMessage(0, 0, 0, 0) # activating process message queue (without any window)
# But if we want to stop we need to terminate process in Task Manager!

var msg: MSG
while GetMessage(msg.addr, 0, 0, 0):
    discard
