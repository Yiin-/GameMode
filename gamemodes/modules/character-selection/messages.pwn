#include <YSI\y_hooks>

hook OnCharacterSelection(playerid) {
	ClearChat(playerid);
	
	M:P:X(playerid, "Pasirinkus norim� veik�j�, ra�yk arba spausk");
	M:P:X(playerid, "[highlight]/zaisti[] (arba [highlight]ENTER[] arba [highlight]SPACE[]) nor�damas prad�ti �aidim�,");
	M:P:X(playerid, "[highlight]/kurti[] (arba [highlight]ALT[]) nor�damas kurti nauj� veik�j�,");
	M:P:X(playerid, "[highlight]/trinti[] i�trinti pasirinkt� veik�j�.");
}

hook OnPlayerSelectsCharName(playerid, name[]) {
	M:P:G(playerid, "Veik�jo vardas \"[name]%s[]\" yra laisvas! Dabar i�sirink savo veik�jo i�vaizd�.", name);
}

hook OnCharacterCreated(playerid) {
	M:P:G(playerid, "Veik�jas [name]%s[] s�kmingai sukurtas!", GetPlayerName(playerid));
}

hook OnCharacterDeleted(playerid, index) {
	M:P:G(playerid, "Veik�jas s�kmingai i�trintas!");
}

hook OnCharCreationError(playerid, error) {
	switch(error) {
		case CHARACTER_CREATION_ERROR_CHARACTERS_LIMIT_REACHED: {
			M:P:E(playerid, "Pasiektas maksimalus veik�j� skai�ius.");
		}
		case CHARACTER_CREATION_ERROR_NAME_ALREADY_EXISTS: {
			M:P:E(playerid, "�is veik�jo vardas jau yra u�imtas.");
		}
	}
}

hook OnCharacterSpawn(playerid) {
	ClearChat(playerid);
}