import XMonad

import XMonad.Layout.Spacing
import XMonad.Layout.Tabbed
import XMonad.Layout.NoBorders

import XMonad.ManageHook
import XMonad.Hooks.ManageHelpers

import XMonad.Util.EZConfig

import XMonad.Actions.NoBorders

import Control.Monad (liftM2)
import qualified XMonad.StackSet as W

import XMonad.Actions.WindowBringer

myLayoutHook = (tabbed shrinkText def) ||| layoutHook defaultConfig

myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

myShiftHooks = composeAll
	[
		className =? "Terminator"		--> viewShift	(myWorkspaces !! 0)
	,	className =? "Geany"			--> viewShift	(myWorkspaces !! 1)
	,	className =? "Firefox"			--> viewShift	(myWorkspaces !! 2)
	,	className =? "Chromium"			--> viewShift	(myWorkspaces !! 2)
	,	className =? "Spacefm"			--> viewShift	(myWorkspaces !! 3)
	,	className =? "Vlc"			--> viewShift	(myWorkspaces !! 6)
	,	className =? "Tixati"			--> doShift	(myWorkspaces !! 8)
	]
	where viewShift = doF . liftM2 (.) W.greedyView W.shift

myFloatHooks = composeAll
	[
		resource =? "Vlc"			--> doFloat
	]

main = xmonad $ defaultConfig
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
	,	((mod1Mask, xK_g ), gotoMenu)
	,	((mod1Mask, xK_b ), bringMenu)
	]
