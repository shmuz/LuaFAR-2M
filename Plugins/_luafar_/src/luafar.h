#ifndef LUAFAR_H
#define LUAFAR_H

#include <farplug-wide.h>

#ifdef __cplusplus
extern "C" {
#endif

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

#ifndef DLLFUNC
#define DLLFUNC __attribute__ ((visibility ("default")))
#endif

DLLFUNC lua_State* LF_LuaOpen(struct PluginStartupInfo *Info, lua_CFunction aOpenLibs, const char* aEnvPrefix, void** dlopen_handle);
DLLFUNC void LF_InitLuaState(lua_State *L, struct PluginStartupInfo *Info, lua_CFunction aOpenLibs, const char* aEnvPrefix);
DLLFUNC void LF_LuaClose(lua_State* L, void* dlopen_handle);
DLLFUNC int  LF_Message(struct PluginStartupInfo *Info, const wchar_t* aMsg, const wchar_t* aTitle, const wchar_t* aButtons, const char* aFlags, const wchar_t* aHelpTopic);
DLLFUNC BOOL LF_RunDefaultScript(lua_State* L);
DLLFUNC int  LF_LoadFile(lua_State *L, const wchar_t* filename);
DLLFUNC const wchar_t *LF_Gsub (lua_State *L, const wchar_t *s, const wchar_t *p, const wchar_t *r);

DLLFUNC void   LF_ClosePlugin (lua_State* L, HANDLE hPlugin);
DLLFUNC int    LF_Compare (lua_State* L, HANDLE hPlugin,const struct PluginPanelItem *Item1,const struct PluginPanelItem *Item2,unsigned int Mode);
DLLFUNC int    LF_Configure (lua_State* L, int ItemNumber);
DLLFUNC int    LF_DeleteFiles (lua_State* L, HANDLE hPlugin,struct PluginPanelItem *PanelItem,int ItemsNumber,int OpMode);
DLLFUNC void   LF_ExitFAR (lua_State* L);
DLLFUNC void   LF_FreeFindData (lua_State* L, HANDLE hPlugin,struct PluginPanelItem *PanelItem,int ItemsNumber);
DLLFUNC void   LF_FreeVirtualFindData (lua_State* L, HANDLE hPlugin,struct PluginPanelItem *PanelItem,int ItemsNumber);
DLLFUNC int    LF_GetFiles (lua_State* L, HANDLE hPlugin,struct PluginPanelItem *PanelItem,int ItemsNumber,int Move,const wchar_t **DestPath,int OpMode);
DLLFUNC int    LF_GetFindData (lua_State* L, HANDLE hPlugin,struct PluginPanelItem **pPanelItem,int *pItemsNumber,int OpMode);
DLLFUNC void   LF_GetOpenPluginInfo (lua_State* L, HANDLE hPlugin,struct OpenPluginInfo *Info);
DLLFUNC void   LF_GetPluginInfo (lua_State* L, struct PluginInfo *Info);
DLLFUNC int    LF_GetVirtualFindData (lua_State* L, HANDLE hPlugin,struct PluginPanelItem **pPanelItem,int *pItemsNumber,const wchar_t *Path);
DLLFUNC int    LF_MakeDirectory (lua_State* L, HANDLE hPlugin,const wchar_t **Name,int OpMode);
DLLFUNC int    LF_MayExitFAR (lua_State* L);
DLLFUNC HANDLE LF_OpenFilePlugin (lua_State* L, const wchar_t *Name,const unsigned char *Data,int DataSize,int OpMode);
DLLFUNC HANDLE LF_OpenPlugin (lua_State* L, int OpenFrom,INT_PTR Item);
DLLFUNC int    LF_ProcessDialogEvent (lua_State* L, int Event,void *Param);
DLLFUNC int    LF_ProcessEditorEvent (lua_State* L, int Event,void *Param);
DLLFUNC int    LF_ProcessEditorInput (lua_State* L, const INPUT_RECORD *Rec);
DLLFUNC int    LF_ProcessEvent (lua_State* L, HANDLE hPlugin,int Event,void *Param);
DLLFUNC int    LF_ProcessHostFile (lua_State* L, HANDLE hPlugin,struct PluginPanelItem *PanelItem,int ItemsNumber,int OpMode);
DLLFUNC int    LF_ProcessKey (lua_State* L, HANDLE hPlugin,int Key,unsigned int ControlState);
DLLFUNC int    LF_ProcessSynchroEvent (lua_State* L, int Event,void *Param);
DLLFUNC int    LF_ProcessViewerEvent (lua_State* L, int Event,void *Param);
DLLFUNC int    LF_PutFiles (lua_State* L, HANDLE hPlugin,struct PluginPanelItem *PanelItem,int ItemsNumber,int Move,int OpMode);
DLLFUNC int    LF_SetDirectory (lua_State* L, HANDLE hPlugin,const wchar_t *Dir,int OpMode);
DLLFUNC int    LF_SetFindList (lua_State* L, HANDLE hPlugin,const struct PluginPanelItem *PanelItem,int ItemsNumber);
DLLFUNC int    LF_GetCustomData(lua_State* L, const wchar_t *FilePath, wchar_t **CustomData);
DLLFUNC void   LF_FreeCustomData(lua_State* L, wchar_t *CustomData);

#ifdef __cplusplus
}
#endif

#endif // LUAFAR_H
