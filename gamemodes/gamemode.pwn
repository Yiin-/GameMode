#include <a_samp>

/**
 * I�jungiam warning 213: tag mismatch
 * d�l y_inline pakeitim�, kad callback: parametras funkcijoje b�t� optional
 */
#pragma warning disable 213

/**
 * YSI (http://forum.sa-mp.com/showthread.php?t=570884)
 */
#include <YSI\y_testing> // modified
#include <YSI\y_va>
#include <YSI\y_iterate>
#include <YSI\y_inline>
#include <YSI\y_timers>
#include <YSI\y_commands>
#include <YSI\y_dialog> // modified

/**
 * Vendor
 */
#include <a_mysql> // http://forum.sa-mp.com/showthread.php?t=56564
#include <noclass> // http://forum.sa-mp.com/showthread.php?t=574072
#include <streamer> // http://forum.sa-mp.com/showthread.php?t=102865
#include <djson> // http://forum.sa-mp.com/showthread.php?t=48439
#include <attachments-fix> // http://forum.sa-mp.com/showthread.php?t=584708
#include <formatex> // http://forum.sa-mp.com/showthread.php?t=313488
#include <strlib> // http://forum.sa-mp.com/showthread.php?t=85697
#include <whirlpool> // http://forum.sa-mp.com/showthread.php?t=570945
#include <sscanf2> // http://forum.sa-mp.com/showthread.php?t=570927

/**
 * Utils
 */
#include "..\gamemodes\utils\pawn.pwn"
#include "..\gamemodes\utils\chat.pwn"
#include "..\gamemodes\utils\dialogs.pwn"
#include "..\gamemodes\utils\player.pwn"
#include "..\gamemodes\utils\text.pwn"
#include "..\gamemodes\utils\textdraws.pwn"
#include "..\gamemodes\utils\time.pwn"
#include "..\gamemodes\utils\samp.pwn"
#include "..\gamemodes\utils\virtual_worlds.pwn"

/**
 * Testai
 */
#define RUN_TESTS

#include <YSI\y_testing>
#include "..\gamemodes\tests\database.pwn"

/**
 * Nustatymai
 */
#include "..\gamemodes\config.pwn"

/**
 * Duomen� baz�
 */
#include "..\gamemodes\database\hooks.pwn"
#include "..\gamemodes\database\database.pwn"

/**
 * Authentication (�aid�j�)
 */
#include "..\gamemodes\modules\auth\hooks.pwn"
#include "..\gamemodes\modules\auth\messages.pwn"
#include "..\gamemodes\modules\auth\password_recovery.pwn"
#include "..\gamemodes\modules\auth\auth.pwn"

/**
 * �aid�jas
 *
 * �aid�jas n�ra veik�jas tik veik�jo pasirinkimo lange,
 * tod�l �itas modulis yra pavadintas player, o ne character,
 * nes i� esm�s jie beveik visada rei�kia t� pat�, o kai nerei�kia,
 * tai tam yra atskiras modulis character-selection.
 */
#include "..\gamemodes\modules\player\hooks.pwn"
#include "..\gamemodes\modules\player\orm.pwn"
#include "..\gamemodes\modules\player\position.pwn"
#include "..\gamemodes\modules\player\skins.pwn"
#include "..\gamemodes\modules\player\camera.pwn"
#include "..\gamemodes\modules\player\state.pwn"
#include "..\gamemodes\modules\player\fight.pwn"

/**
 * Veik�jo pasirinkimas
 */
#include "..\gamemodes\modules\character-selection\hooks.pwn"
#include "..\gamemodes\modules\character-selection\definitions.pwn"
#include "..\gamemodes\modules\character-selection\messages.pwn"
#include "..\gamemodes\modules\character-selection\textdraws.pwn"
#include "..\gamemodes\modules\character-selection\commands.pwn"
#include "..\gamemodes\modules\character-selection\spawn.pwn"
#include "..\gamemodes\modules\character-selection\character_selection.pwn"

main() {
}

CMD:vw(playerid, params[]) {
	new vw = strval(params);

	SetPlayerVirtualWorld(playerid, vw);

	M:P:I(playerid, "Your new virtual world: %i", vw);

	return true;
}

CMD:add(playerid, params[]) {
	new Float:x, Float:y, Float:z, Float:a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	new actorid = CreateActor(168, x, y, z, a);

	SetActorVirtualWorld(actorid, GetPlayerVirtualWorld(playerid));

	M:P:I(playerid, "Created actor: %i", actorid);

	return true;
}

CMD:remove(playerid, params[]) {
	new actorid = strval(params);

	if(DestroyActor(actorid)) {
		M:P:I(playerid, "Destroyed actor: %i", actorid);
	}
	else {
		M:P:E(playerid, "Couldn't destroy actor: %i", actorid);
	}

	return true;
}