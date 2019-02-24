--[[----------------------------------------------------------
Hitmarker Config File

Here you will make changes to the configuration of this addon.

allow_everyone - Setting this to true will allow everyone on the
server to configure their own hitmarker settings in the ingame
configuration gui. Setting this to false will only allow
the groups you add belowto be able to change the settings for
everyone on the server. Default is superadmin.

open_command - This string is what will open the ingame
configuration gui with either /yourCommand !yourCommand in the
chatbox and just yourCommand with no arguments in the console.

admin_groups - groups added here will be allowed to change the
hitmarker settings if you have allow_everyone set to false.
]]------------------------------------------------------------
_hm.cfg = _hm.cfg or
{
	allowEveryone = true,
	open_command = "hitmarker",
	admin_groups = 
	{
		["superadmin"] = true,
	},
}