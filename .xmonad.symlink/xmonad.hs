import XMonad

import XMonad.Layout.Spacing
import XMonad.Layout.Tabbed
import XMonad.Layout.NoBorders

import XMonad.ManageHook
import XMonad.Hooks.ManageHelpers

import XMonad.Util.EZConfig

import XMonad.Actions.NoBorders

myLayoutHook = (tabbed shrinkText def) ||| layoutHook defaultConfig

myManageHook = composeAll [
    resource =? "VLC" --> doFloat
  ]

newManageHook = myManageHook <+> manageHook defaultConfig

main = xmonad $ defaultConfig
  {
    normalBorderColor = "#332d29",
    focusedBorderColor = "#817267",
    borderWidth = 4,
    terminal = "terminator",
    modMask  = mod1Mask,
    manageHook = newManageHook,
    layoutHook = myLayoutHook
  }
  `additionalKeys`
  [
    ((mod1Mask .|. shiftMask , xK_b), withFocused toggleBorder)
  ]
