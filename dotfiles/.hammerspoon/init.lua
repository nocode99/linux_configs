-- enable lookup for to spotlight
hs.application.enableSpotlightForNameSearches(true)

local win = hs.window.focusedWindow()
local f = win:frame()
local screen = win:screen()
local max = screen:frame()

print(f)
print(max.w)
print(max.h)

-- Map app to the left half of the screen
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function()
  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

-- Map app to the right half of the screen
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Right", function()
  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

local laptopScreen = "Color LCD"
local mainMonitor = "LG HDR WQHD"

-- Define position values that don't exist by default in hs.layout.*
local positions = {
  leftSide = {x=0, y=0, w=0.5, h=1.0},
  rightSide = {x=0.5, y=0, w=0.5, h=1.0},
  leftTop = {x=0, y=0, w=0.5, h=0.5},
  leftBottom = {x=0, y=0.5, w=0.5, h=0.5},
  rightTop = {x=0.5, y=0, w=0.5, h=0.5},
  rightBottom = {x=0.5, y=0.5, w=0.5, h=0.5}
}

local firefox="Firefox"
local slack="Slack"
local outlook="Microsoft Outlook"
local kitty="kitty"
local workspaces="WorkSpacesClient.macOS"
local vscode="Code"
local appNames = {
  firefox,
  slack,
  outlook,
  kitty,
  workspaces,
}


local lgWideScreen = {
  {firefox, nil, mainMonitor, positions.leftSide, nil, nil},
  {slack, nil, mainMonitor, positions.leftSide, nil, nil},
  {outlook, nil, mainMonitor, positions.leftSide, nil, nil},
  {kitty, nil, mainMonitor, positions.rightSide, nil, nil},
  {workspaces, nil, mainMonitor, positions.rightSide, nil, nil},
  {vscode, nil, mainMonitor, positions.rightSide, nil, nil},
}

local layoutSingleScreen = {
  {firefox, nil, mainMonitor, hs.layout.maximized, nil, nil},
  {slack, nil, mainMonitor, hs.layout.maximized, nil, nil},
  {outlook, nil, mainMonitor, hs.layout.maximized, nil, nil},
  {kitty, nil, mainMonitor, hs.layout.maximized, nil, nil},
  {workspaces, nil, mainMonitor, hs.layout.maximized, nil, nil},
  {vscode, nil, mainMonitor, hs.layout.maximized, nil, nil},
}

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Up", function()
  hs.layout.apply(lgWideScreen)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Down", function()
  hs.layout.apply(layoutSingleScreen)
end)