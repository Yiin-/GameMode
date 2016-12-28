#include <YSI\y_hooks>

/**
 * Variables
 */

static s_PlayerAccountName[MAX_PLAYERS][MAX_PLAYER_NAME];
static s_PlayerEmail[MAX_PLAYERS][200];
static s_StatusMessage[500];

/**
 * Public methods
 */

stock GetPlayerAccountName(playerid, name[] = "", len = sizeof name) {
	format(name, len, s_PlayerAccountName[playerid]);

	return s_PlayerAccountName[playerid];
}

stock PlayerHasEmail(playerid) {
	return !isnull(s_PlayerEmail[playerid]);
}

stock GetPlayerEmail(playerid, email[] = "", len = sizeof email) {
	format(email, len, s_PlayerEmail[playerid]);

	return s_PlayerEmail[playerid];
}

stock AuthStatusMessage(const text[], va_args<>) {
	va_formatex(s_StatusMessage, _, text, va_start<1>);
}

/**
 * Events
 */

hook OnPlayerConnect(playerid) {
	// i�sisaugom �aid�jo acc name
	GetPlayerName(playerid, s_PlayerAccountName[playerid], MAX_PLAYER_NAME);

	SetPVarInt(playerid, "cache", _:mysql_query("SELECT uid, email, password FROM users WHERE username = '%s'", s_PlayerAccountName[playerid]));
}

hook OnPlayerFullyConnected(playerid) {
	new Cache:cache = Cache:GetPVarInt(playerid, "cache");
	DeletePVar(playerid, "cache");

	cache_set_active(cache);

	if(cache_num_rows()) {
		// i�sisaugom �aid�jo el. pa�t�
		cache_get_value_name(0, "email", s_PlayerEmail[playerid]);

		login(playerid, cache);
	}
	else {
		cache_delete(cache);
		register(playerid);
	}
}

hook OnPlayerDisconnect(playerid, reason) {
	if(GetPVarType(playerid, "cache")) {
		cache_delete(Cache:GetPVarInt(playerid, "cache"));
	}
}

/**
 * Methods
 */

static login(playerid, Cache:cache, fails = 0) {
	AuthStatusMessage("Nor�damas prisijungti �vesk savo slapta�od�.");

	if(fails) {
		call OnPlayerLoginFailed(playerid, fails);

		if(fails == 3) {
			cache_delete(cache);

			call OnPlayerLeaveServer(playerid);
			defer Kick(playerid);
			return;
		}
	}
	inline OnPlayerEnterPassword(response) {
		if(response) {
			static hashed_input_password[129];
			WP_Hash(hashed_input_password, sizeof hashed_input_password, GetInputText());

			static hashed_real_password[129];
			cache_get_value_name(0, "password", hashed_real_password);

			if( ! strcmp(hashed_input_password, hashed_real_password)) {
				new user_id = cache_get_value_name_int(0, "uid");
				cache_delete(cache);

				call OnPlayerLogin(playerid, user_id);
			}
			else {
				login(playerid, cache, fails + 1);
			}
		}
		else {
			// Jeigu �aid�jas buvo blogai �ved�s slapta�od�, siun�iam slapta�od�io priminimo lai�k�
			if(fails && PlayerHasEmail(playerid)) {
				inline OnPlayerRequestNewPassword(send) {
					if(send) {
						call OnPlRequestNewPassword(playerid);
					}
					call OnPlayerLeaveServer(playerid);
					defer Kick(playerid);
				}
				SetDialogHeader("Naujo slapta�od�io pra�ymas");
				SetDialogBody("\
					Naujo slapta�od�io patvirtinimo lai�kas bus i�si�stas el. pa�tu [highlight]%s[].\n\
					\n\
					Patvirtinus naujo slapta�od�io siuntim�, tavo slapta�odis bus automati�kai sugeneruotas � kit�, \n\
					ir atsi�stas � t� pat� el. pa�to adres�.\
				", GetPlayerEmail(playerid));

				ShowDialog(playerid, using inline OnPlayerRequestNewPassword, DIALOG_STYLE_MSGBOX, 
					"Naujo slapta�od�io pra�ymas",
					"Si�sti", "I�eiti");
			}
			else { // Kitu atveju paklausiam ar jis tikrai nori palikti server�
				inline ExitWarningResponse(stay) {
					if(stay) {
						login(playerid, cache, fails);
					}
					else {
						cache_delete(cache);

						call OnPlayerLeaveServer(playerid);
						defer Kick(playerid);
					}
				}
				SetDialogHeader("Ar tikrai nori palikti server�?");
				SetDialogBody("\
					Norint �aisti serveryje, privaloma prisijungti, \n\
					ta�iau jeigu nori palikti server� - paspausk mygtuk� \"I�eiti\"\
				");

				ShowDialog(playerid, using inline ExitWarningResponse, DIALOG_STYLE_MSGBOX, 
					"I��jimas i� serverio",
					"Prisijungti", "I�eiti");
			}
		}
	}
	SetDialogHeader("Prisijungimas prie serverio");
	SetDialogBody(s_StatusMessage);

	ShowDialog(playerid, using inline OnPlayerEnterPassword, DIALOG_STYLE_PASSWORD, "Prisijungimas", "Prisijungti", (fails && PlayerHasEmail(playerid)) ? ("Pamir�au") : ("I�eiti"));
}

static register(playerid) {
	static serial[128];
	gpci(playerid, serial, sizeof serial);

	inline OnPlayerEnterNewPassword(response) {
		if(response) {
			call OnPlEnterNewPassword(playerid);

			static password[129];
			WP_Hash(password, sizeof password, GetInputText());

			inline OnPlayerEnterEmail(accepted) {
				new email[200];

				if(accepted) {
					format(email, sizeof email, GetInputText());
				}

				new Cache:cache = mysql_query("\
					INSERT INTO                \
						users (                \
							username,          \
							password,          \
							email,             \
							last_gpci,         \
							last_ip            \
						)                      \
					VALUES (                   \
						'%s',                  \
						'%s',                  \
						'%s',                  \
						'%s',                  \
						%i                     \
					)                          \
				", GetPlayerAccountName(playerid), password, email, serial, compressPlayerIP(playerid));
				
				new user_id = cache_insert_id();
				cache_delete(cache);

				call OnPlayerRegister(playerid, user_id);
			}
			SetDialogHeader("Naujo �aid�jo registracija");
			SetDialogBody("\
				Norint ateityje susigr��inti pamir�t� slapta�od�, pra�ome �vesti savo el. pa�to adres�.\n\
				Jis n�ra privalomas, ta�iau gali labai praversti. \n\
				\n\
				Patvirtinus el. pa�t�, [highlight]nemokamai gausi 300�[]\n\
				ir [highlight]galimyb� 24 valandas nemokamai naudotis dvira�i� nuomos paslauga[].");
			ShowDialog(playerid, using inline OnPlayerEnterEmail, DIALOG_STYLE_INPUT, "Registracija", "I�saugoti", "I�eiti");
		}
		else {
			inline ExitWarningResponse(stay) {
				if(stay) {
					register(playerid);
				}
				else {
					call OnPlayerLeaveServer(playerid);
					defer Kick(playerid);
				}
			}
			SetDialogHeader("Ar tikrai nori palikti server�?");
			SetDialogBody("\
				Norint �aisti serveryje, privaloma prisijungti, \n\
				ta�iau jeigu nori palikti server� - paspausk mygtuk� \"I�eiti\"\
			");

			ShowDialog(playerid, using inline ExitWarningResponse, DIALOG_STYLE_MSGBOX, 
				"I��jimas i� serverio",
				"Registruotis", "I�eiti");
		}
	}
	SetDialogHeader("Naujo �aid�jo registracija");
	SetDialogBody("Nor�damas u�siregistruoti, �vesk savo norim� slapta�od�.");
	ShowDialog(playerid, using inline OnPlayerEnterNewPassword, DIALOG_STYLE_PASSWORD, "Registracija", "Patvirtinti", "I�eiti");
}

static compressPlayerIP(playerid) {
	static ip_address[16];
	GetPlayerIp(playerid, ip_address, 16);

	static ip[4];
	sscanf(ip_address, "p<.>a<i>[4]", ip);

	return (ip[0] * 16777216) + (ip[1] * 65536) + (ip[2] * 256) + (ip[3]);
}