import XMonad

import XMonad.Util.EZConfig			-- additionalKeys
import XMonad.Layout.NoBorders			-- NoBorders
import XMonad.Layout.Spacing			-- spacing $ Tall
import Control.Monad (liftM2)			-- viewShift
import qualified XMonad.StackSet as W		-- viewShift
import XMonad.Hooks.EwmhDesktops		-- EWMH
import XMonad.Actions.WindowGo (runOrRaise)	-- startupHook


myLayoutHook = (noBorders Full) ||| tall ||| Mirror tall
		where tall = (spacing 2 $ Tall 1 (3/100) (3/5))

myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

myShiftHooks = composeAll
	[
		className =? "Terminator"		--> viewShift	(myWorkspaces !! 0)
	,	className =? "Alacritty"		--> viewShift	(myWorkspaces !! 0)
	,	className =? "Geany"			--> viewShift	(myWorkspaces !! 1)
	,	className =? "Code"			--> viewShift	(myWorkspaces !! 1)
	,	className =? "jetbrains-webstorm"	--> viewShift	(myWorkspaces !! 1)
	,	className =? "jetbrains-phpstorm"	--> viewShift	(myWorkspaces !! 1)
	,	className =? "Subl3"			--> viewShift	(myWorkspaces !! 1)
	,	className =? "TeXstudio"		--> viewShift	(myWorkspaces !! 1)
	,	className =? "Navigator"		--> viewShift	(myWorkspaces !! 2)
	,	className =? "Firefox"			--> viewShift	(myWorkspaces !! 2)
	,	className =? "firefox"			--> viewShift	(myWorkspaces !! 2)
	,	className =? "Chromium"			--> viewShift	(myWorkspaces !! 2)
	,	className =? "Nightly"			--> viewShift	(myWorkspaces !! 2)
	,	className =? "Spacefm"			--> viewShift	(myWorkspaces !! 3)
	,	className =? "VirtualBox"		--> viewShift	(myWorkspaces !! 4)
	,	className =? "Steam"			--> viewShift	(myWorkspaces !! 5)
	,	className =? "Vlc"			--> viewShift	(myWorkspaces !! 6)
	,	className =? "smplayer"			--> viewShift	(myWorkspaces !! 6)
	,	className =? "mpv"			--> viewShift	(myWorkspaces !! 6)
	,	className =? "discord"			--> viewShift	(myWorkspaces !! 7)
	,	className =? "TelegramDesktop"		--> viewShift	(myWorkspaces !! 7)
	,	className =? "Slack"			--> doShift	(myWorkspaces !! 7)
	,	className =? "Tixati"			--> doShift	(myWorkspaces !! 8)
	,	className =? "Deluge"			--> doShift	(myWorkspaces !! 8)
	]
	where viewShift = doF . liftM2 (.) W.greedyView W.shift

myStartupHook :: X()
myStartupHook = do
	runOrRaise "tixati" (className =? "Tixati")
	runOrRaise "alacritty" (className =? "Alacritty")

main = xmonad $ ewmh $ defaultConfig
	{
		normalBorderColor = "#332d29"
	,	focusedBorderColor = "#817267"
	,	borderWidth = 2
	,	terminal = "alacritty"
	,	modMask  = mod1Mask
	,	layoutHook = lessBorders OnlyScreenFloat $ myLayoutHook
	,	workspaces = myWorkspaces
	,	manageHook = myShiftHooks <+> manageHook defaultConfig
	,	startupHook = myStartupHook
	,	handleEventHook = fullscreenEventHook
  }
	`additionalKeys`
	[
		((mod1Mask, xK_p ), spawn "rofi -show run")
	,	((mod1Mask, xK_g ), spawn "rofi -show window")
	]
