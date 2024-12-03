-- Original author : John Doe
-- Original URL    : https://forum.farmanager.com/viewtopic.php?t=13283

-- https://bito.ai/
-- https://github.com/gitbito/CLI/raw/main/version-3.3/BitoCLI.msi
-- https://github.com/gitbito/CLI/blob/main/version-3.3/bito.exe
-- https://docs.bito.ai/feature-guides/custom-prompt-templates

local osWindows = package.config:sub(1,1)=="\\"

local linewrap = 80
local _name = "bito.ai code assistant"
local _prompt = "&Ask any technical question / use {{%code%}} as seltext placeholder"

local F = far.Flags
local idProgress = win.Uuid"3E5021C5-47C7-4446-8E3B-13D3D9052FD8"
local function progress (text, title)
  local len = math.max(text:len(), title and title:len() or 0, 7)
  local items = {
  --[[01]] {F.DI_SINGLEBOX,0,0,len+4,3,0,0,0,                0, title},
  --[[02]] {F.DI_TEXT,     2,1,    0,1,0,0,0,F.DIF_CENTERGROUP, text},
  }
  return far.DialogInit(idProgress, -1, -1, len+4, 3, nil, items, F.FDLG_NONMODAL)
end

local function GetQuestion()
  local sd = require "far2.simpledialog"
  local items = {
    guid = "58DD9ECD-CFFA-472E-BFD7-042295C86CAE";
    width = 100;
    {tp="dbox"; text=_name; },
    {tp="text"; text=_prompt; },
    {tp="edit"; hist="bito.ai prompt"; uselasthistory=1; name="quest"; },
    {tp="text"; text="&Line wrap:"; },
    {tp="fixedit"; y1=""; x1=16; width=3; mask="999"; text=linewrap; name="wrap"; },
  }
  local out = sd.New(items):Run()
  if out then
    linewrap = tonumber(out.wrap)
    return out.quest
  end
end

local function Words(pipe)
  local buf, eof = "", nil
  return function()
    while true do
      if not eof then
        local chunk = pipe:read(5)
        if chunk then
          buf = buf..chunk
          while not buf:isvalid() do
            chunk = pipe:read(1)
            if chunk then buf = buf..chunk; else break; end
          end
        end
        eof = not chunk
      end
      if buf == "" then return end
      local space, word, other = buf:match("^(%s*)(%S+)(%s.*)")
      if space then
        buf = other
        return space, word
      elseif eof then
        space, word = buf:match("(%s*)(.*)") -- will always match
        buf = ""
        return space, word
      end
    end
  end
end

local function bito (prompt)
  prompt = prompt or GetQuestion()
  if prompt then
    local root = osWindows and win.GetEnv("FARLOCALPROFILE") or far.InMyConfig()
    local ctxName = win.JoinPath(root, "ctx.bito")
    local promptName = win.JoinPath(root, "prompt.bito")
    local fp = assert(io.open(promptName, "w"))
    fp:write(prompt)
    fp:close()
    local ctx = Editor.SelValue
    local fileName = win.JoinPath(root, "file.bito")
    fp = assert(io.open(fileName, "w"))
    fp:write(ctx=="" and " " or ctx)
    fp:close()
    local cmd = ('bito -c "%s" -f "%s" -p "%s"'):format(ctxName, fileName, promptName)
    local flags = F.EF_NONMODAL +F.EF_IMMEDIATERETURN  +F.EF_OPENMODE_USEEXISTING +F.EF_DISABLEHISTORY
    editor.Editor("bito.md", nil, nil, nil, nil, nil, flags, nil, nil, 65001)
    local wi = far.AdvControl(F.ACTL_GETWINDOWINFO)
    assert(wi.Type==F.WTYPE_EDITOR, "oops, editor has not been opened")
    local Id = wi.Id
    editor.SetTitle(Id, "Fetching response...")
    local hDlg = progress("Waiting for data..")
    editor.UndoRedo(Id, F.EUR_BEGIN)
    local ei = editor.GetInfo(Id)
    local s = editor.GetString(Id, ei.TotalLines)
    editor.SetPosition(Id, ei.TotalLines, s.StringLength+1)
    if s.StringLength>0 then
      editor.InsertString(Id)
      editor.InsertString(Id)
      editor.SetPosition(Id, ei.TotalLines+2)
    end
    far.Text()

    local pipe = io.popen(cmd, "r")
    linewrap = linewrap or ei.WindowSizeX-5
    local autowrap = bit64.band(ei.Options, F.EOPT_AUTOINDENT)~=0
    if autowrap then editor.SetParam(nil, F.ESPT_AUTOINDENT, 0) end
    for space,word in Words(pipe) do
      editor.InsertText(Id, space)
      if editor.GetInfo(Id).CurPos + word:len() > linewrap then
        editor.InsertText(Id, "\n")
      end
      editor.InsertText(Id, word)
      editor.Redraw(Id)
      if hDlg then hDlg:Close(); hDlg = nil; end
    end
    pipe:close()
    if hDlg then hDlg:Close() end
    if autowrap then editor.SetParam(Id, F.ESPT_AUTOINDENT, 1) end
    editor.UndoRedo(Id, F.EUR_END)
    editor.SetTitle(Id, "bito.ai response:")
  end
end

if Macro then
  Macro {
    description="Ask AI";
    area="Common"; key="CtrlAltB";
    id="4AFE2367-4DAC-4A74-B1EE-9F14C42991CB";
    action=function()
      mf.acall(bito)
    end;
  }
else
  return bito
end
