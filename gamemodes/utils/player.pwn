timer DelayedKick[200](playerid) {
	Kick(playerid);
}
#define Kick_yT@ DelayedKick_yT@

stock InvalidNick(playerid, name_[])
{
	new name[MAX_PLAYER_NAME];
	
	format(name, _, "%s", FilterLetters(name_));

	new where = strfind(name,"_",true);
	new lenght = strlen(name)-1;
	new invalid = strfind(name,"[",true);
	if(invalid == -1) invalid = strfind(name,"]",true);
	if(invalid == -1) invalid = strfind(name,"'",true);

	if(name[0] < 65 || name[0] > 90)
	{
		M:P:E(playerid, "Vardas turi prasid�ti i� did�iosios raid�s!");
		return 1;
	}

	if(name[where+1] < 65 || name[where+1] > 90)
	{
		M:P:E(playerid, "Pavard� turi prasid�ti i� did�iosios raid�s!");
		return 1;
	}

	for(new i = 1; i < where-1; i++)
	{
		if(name[i] < 97 || name[i] > 122)
		{
			M:P:E(playerid, "Vardo viduryje negali b�ti skai�i� ir/arba did�i�j� raid�i�.");
			return 1;
		}
	}


	if(where == 0 || where == lenght || where==-1)
	{
		M:P:E(playerid, "Blogai �vestas vardas.");
		return 1;
	}

	if(strlen(name[where])<3)
	{
		M:P:E(playerid, "Pavard� turi b�ti ilgesn� negu [number]2[] simboliai.");
		return 1;
	}

	if(where<3)
	{
		M:P:E(playerid, "Vardas turi b�ti ilgesnis negu [number]2[] simboliai.");
		return 1;
	}


	if(invalid != -1)
	{
		M:P:E(playerid, "Vard� ir pavard� gali sudaryti tik raid�s [highlight][A-Z, a-z][].");
		return 1;
	}

	for(new i = where+2; i < MAX_PLAYER_NAME; i++)
	{
		if(name[i] < 97 || name[i] > 122)
		{
			if(name[i] == 0){i = MAX_PLAYER_NAME; return 0;}
			M:P:E(playerid, "Vardo viduryje negali b�ti skai�i� ir/arba did�i�j� raid�i�.");
			return 1;
		}
	}
	return 0;
}