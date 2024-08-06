-- enable lookup for to spotlight
hs.application.enableSpotlightForNameSearches(true)

-- Map app to the left half of the screen
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

-- Map app to the right half of the screen
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Right", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

local laptopScreen = "Color LCD"
local mainMonitor = "LG HDR WQHD"
local secondMonitor = "LG Ultra HD"

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
local kitty="kitty"
local appNames = {
  firefox,
  slack,
  kitty,
}


local lgWideScreen = {
  {firefox, nil, mainMonitor, positions.rightSide, nil, nil},
  {slack, nil, mainMonitor, positions.leftSide, nil, nil},
  {kitty, nil, secondMonitor, hs.layout.maximized, nil, nil},
}

local layoutSingleScreen = {
  {firefox, nil, laptopScreen, hs.layout.maximized, nil, nil},
  {slack, nil, laptopScreen, hs.layout.maximized, nil, nil},
  {kitty, nil, laptopScreen, hs.layout.maximized, nil, nil},
}

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Up", function()
  hs.layout.apply(lgWideScreen)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Down", function()
  hs.layout.apply(layoutSingleScreen)
end)


function moveWindowToDisplay(d)
  return function()
    local displays = hs.screen.allScreens()
    local win = hs.window.focusedWindow()
    win:moveToScreen(displays[d], false, true)
  end
end

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "1", moveWindowToDisplay(1))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "2", moveWindowToDisplay(2))
