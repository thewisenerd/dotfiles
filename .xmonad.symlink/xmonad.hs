import XMonad

import XMonad.Layout.Tabbed		-- layout
import XMonad.Util.EZConfig		-- additionalKeys
import XMonad.Actions.NoBorders		-- toggleBorder
import XMonad.Layout.NoBorders		-- NoBorders
import Control.Monad (liftM2)		-- viewShift
import qualified XMonad.StackSet as W	-- viewShift
import XMonad.Hooks.EwmhDesktops	-- EWMH

myLayoutHook = (noBorders Full) ||| (tabbed shrinkText def) ||| tiled ||| Mirror tiled
	where
		-- default tiling algorithm partitions the screen into two panes
		tiled   = Tall nmaster delta ratio

		-- The default number of windows in the master pane
		nmaster = 1

		-- Default proportion of screen occupied by master pane
		ratio   = 1/2

		-- Percent of screen to increment by when resizing panes
		delta   = 3/100

myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

myShiftHooks = composeAll
	[
		className =? "Terminator"		--> viewShift	(myWorkspaces !! 0)
	,	className =? "Geany"			--> viewShift	(myWorkspaces !! 1)
	,	className =? "Code"			--> viewShift	(myWorkspaces !! 1)
	,	className =? "jetbrains-webstorm"	--> viewShift	(myWorkspaces !! 1)
	,	className =? "jetbrains-phpstorm"	--> viewShift	(myWorkspaces !! 1)
	,	className =? "TeXstudio"		--> viewShift	(myWorkspaces !! 1)
	,	className =? "Firefox"			--> viewShift	(myWorkspaces !! 2)
	,	className =? "Chromium"			--> viewShift	(myWorkspaces !! 2)
	,	className =? "Navigator"		--> viewShift	(myWorkspaces !! 2)
	,	className =? "Nightly"			--> viewShift	(myWorkspaces !! 2)
	,	className =? "Spacefm"			--> viewShift	(myWorkspaces !! 3)
	,	className =? "VirtualBox"		--> viewShift	(myWorkspaces !! 4)
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

myFloatHooks = composeAll
	[
		resource =? "Vlc"			--> doFloat
	]

main = xmonad $ ewmh $ defaultConfig
	{
		normalBorderColor = "#332d29"
	,	focusedBorderColor = "#817267"
	,	borderWidth = 4
	,	terminal = "terminator"
	,	modMask  = mod1Mask
	,	layoutHook = myLayoutHook
	,	workspaces = myWorkspaces
	,	manageHook = myShiftHooks <+> myFloatHooks <+> manageHook defaultConfig
  }
	`additionalKeys`
	[
		((mod1Mask .|. shiftMask , xK_b), withFocused toggleBorder)
	,	((mod1Mask, xK_p ), spawn "rofi -show run")
	,	((mod1Mask, xK_g ), spawn "rofi -show window")
	]
