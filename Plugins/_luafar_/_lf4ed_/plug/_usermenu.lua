local function ReloadUserFile()
  lf4ed.reload()
  far.Message("User file reloaded","LF4Ed","")
  win.Sleep(600)
  actl.RedrawAll()
end

local function SmartHome()
  local info, str = editor.GetInfo(), editor.GetString()
  local pos = str.StringText:find("%S") or 1
  editor.SetPosition(nil, pos==info.CurPos and 1 or pos)
  editor.Redraw()
end

-- main user menu file
AddToMenu ("e", nil, "Ctrl+1", 1)
AddToMenu ("e", nil, "Ctrl+2", 2)
AddToMenu ("e", nil, "Ctrl+3", 3)
AddToMenu ("e", nil, "Ctrl+4", 4)
AddToMenu ("e", nil, "Ctrl+5", 5)
AddToMenu ("e", nil, "Ctrl+6", 6)

AddToMenu ("e", ":sep:")
AddToMenu ("e", nil, "Ctrl+E",        "scripts/bracket.lua")
AddToMenu ("e", nil, "Ctrl+F9",       "scripts/calc.lua")
AddToMenu ("e", nil, "Ctrl+Shift+F7", "scripts/editor_luacheck.lua")
AddToMenu ("e", nil, "Home", SmartHome)
AddToMenu ("depv", "Macro Browser", nil, "scripts/macrobrowser.lua")
AddToMenu ("depv", "Lua Calc",      nil, function() require("far2/calc")() end)

AddCommand("macrobrowser", "scripts/macrobrowser.lua")
AddCommand("reload", ReloadUserFile)
AddUserFile("scripts/editor_events.lua")
AddUserFile("scripts/dup_line.lua")

-- WARNING: The following 2 utilities may rename or delete your files.
--          They are not tested enough. Do not run them.
--local PluginDir = far.PluginStartupInfo().ModuleName:match(".+/")
--AddToMenu("p", "Delete Trees", nil, "scripts/del_trees.lua",
--          "<"..PluginDir.."scripts/>DeleteTrees") -- help topic
--AddToMenu("p", "Rename", nil, "scripts/lf_rename.lua",
--          "<"..PluginDir.."scripts/>Rename")      -- help topic

------------------------------------------------------------------------------
if os.getenv("USER") == "shmuel" then
  AddToMenu ("e", ":sep:")
  AddToMenu ("e", "Test: Sort Lines",       nil,      "scripts/test_sortlines.lua")
  AddToMenu ("e", "Multiline Search",       "Ctrl+7", "scripts/multiline.lua")
  AddToMenu ("e", "Multiline Search Again", "Ctrl+8", "scripts/multiline.lua", true)
  AddUserFile("scripts/lf_fin.lua")
  AddUserFile("scripts/scite_like.lua")
  AddUserFile("scripts/dupfighter/dupfighter.lua")
end
