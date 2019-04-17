--[[------------------------------------------------------------
Hitmarker Config File

Here you will make changes to the configuration of this addon.

allow_everyone - Setting this to true will allow everyone on the
server to configure their own hitmarker settings in the ingame
configuration gui. Setting this to false will only allow
the groups you add belowto be able to change the settings for
everyone on the server. Default is superadmin.

open_command - This string is what will open the ingame
configuration gui. With the default option, the chat command to
open will be /hitmarker or !hitmarker, the console command
will just be hitmarker.

hitmarker_last - This sets how long in seconds a hitmarker will last
on a players screen after creation (the player hit an entity).

admin_groups - groups added here will be allowed to change the
hitmarker settings if you have allow_everyone set to false.
]]--------------------------------------------------------------
_hm.cfg = _hm.cfg or
{
	allow_everyone = true,

	open_command = "hitmarker",

	hitmarker_last = 0.2,

	admin_groups = 
	{
		["superadmin"] = true,
	},
}