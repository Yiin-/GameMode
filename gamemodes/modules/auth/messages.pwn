/**
 * auth/messages.pwn
 *
 * �aid�jo autentifikavimo �inu�i� valdymas
 *
 * Dependencies:
 *  - auth/auth
 */

#include <YSI\y_hooks>

hook OnPlayerFullyConnected(playerid) {
	ClearChat(playerid);
	M:P:I(playerid, "[name]%s[], sveikas prisijung�s prie [highlight]Story of Cities[] serverio!", GetPlayerAccountName(playerid));
	M:P:I(playerid, "Linkime gerai praleisti laik�! :)");
}

hook OnPlayerLoginFailed(playerid, fails) {
	switch(fails) {
		case 1: {
			static const message[] = "Hm, pana�u, kad suklydai �vesdamas slapta�od�, pam�gink dar kart�!";
			AuthStatusMessage(message);

			M:P:E(playerid, message);
		}
		case 2: {
			static const message[][] = {
				"Ir v�l nepataikei :(",
				"Jeigu neatsimeni savo slapta�od�io, spausk [highlight]Pamir�au[] ir pasi�lysim atsi�sti nauj�.",
				"Jeigu neatsimeni savo slapta�od�io susisiek su administracija.",
				"�inoma jeigu manai kad �� kart� tikrai tas, gali bandyti dar vien� kart�."
			};
			AuthStatusMessage("%s\n%s\n%s", message[0], PlayerHasEmail(playerid) ? message[1] : message[2], message[3]);

			M:P:E(playerid, message[0]);
			M:P:I(playerid, PlayerHasEmail(playerid) ? message[1] : message[2]);
			M:P:I(playerid, message[3]);
		}
		default: {
			static const message[][200] = {
				"Well shit, pana�u, kad ir ne �itas.",
				"Galime atsi�sti nauj� slapta�od� el. pa�tu [highlight]%s[] arba susisiek su administracija.",
				"D�l naujo slapta�od�io susisiek su administracija."
			};
			static message1[200];
			format(message1, sizeof message1, message[1], GetPlayerEmail(playerid));

			AuthStatusMessage("%s\n%s", message[0], PlayerHasEmail(playerid) ? message1 : message[2]);

			M:P:E(playerid, message[0]);

			if(PlayerHasEmail(playerid)) {
				M:P:I(playerid, message1);
			}
			else {
				M:P:I(playerid, message[2]);
			}
		}
	}
}

hook OnPlayerLogin(playerid, user_id) {
	M:P:G(playerid, "Slapta�odis teisingas, prisijungei s�kmingai!");
}

hook OnPlEnterNewPassword(playerid) {
	M:P:G(playerid, "Puiku, tik nepamir�k savo pasirinkto slapt�od�io!");
	M:P:I(playerid, "Pamir�us slapta�od�, j� galime atsi�sti nauj� � pasirinkt� el. pa�to adres�.");
}

hook OnPlayerRegister(playerid, user_id) {
	M:P:G(playerid, "U�siregistravai s�kmingai, s�km�s �aidime!");
}

hook OnPlRequestNewPassword(playerid) {
	M:P:I(playerid, "Naujo slapta�od�io patvirtinimo lai�kas buvo i�si�stas el. pa�tu [highlight]%s[].", GetPlayerEmail(playerid));
	M:P:I(playerid, "Patvirtinus siuntim�, � t� pat� el. pa�to adres� bus atsi�stas naujas slapta�odis.");
}

hook OnPlayerLeaveServer(playerid) {
	M:P:I(playerid, "Lauksim sugr��tant!");
}