//Musica Variada al inicio de tu servidor by Zavalak47
/*

Este Filterscript te permite reproducir musica variada al inicio de tu servidor
Para que funcione debes tener las canciones a reproducir en tu webhost.
 
 Ejemplo:
 Debes guardar las canciones a reproducir con el nombre "cancion.mp3" si quieres
 tener 3 canciones diferentes debes comenzar con "cancion.mp3", "cancion1.mp3", "cancion2.mp3"

*/

#include <a_samp>
#define COL_ROJO 0x9F0000FF

//Configuraciones:

#define MAX_CANCIONES (3) //Aca colocan la cantidad de canciones que usaras.
new PrimeraCancion[] = "http://www.tuservidor.com/musica/cancion.mp3"; //Aca colocas la ruta de la primera cancion.mp3 (esta no debe contener ningun numero)
new Link[] = "http://www.tuservidor.com/musica/cancion%i.mp3"; //Aca coloca la ruta donde guardaras las canciones en tu host.

//
new Sonido[MAX_PLAYERS];
new bool:MusicaActiva = true;

#define FILTERSCRIPT
#if defined FILTERSCRIPT
	public OnFilterScriptInit()
	{
		print(" Musica al inicio de tu servidor - Correctamente Cargada.");
		return 1;
	}
	public OnFilterScriptExit()
	{
		return 1;
	}
	#else
	main()
	{
		print(" Musica al inicio de tu servidor - Error (definir como filterscript).");
	}
#endif

Variar(num1, num2)
{
new num = random(num2 - num1) + num1;
return num;
}

public OnPlayerConnect(playerid)
{
	Sonido[playerid] = 1;
	if(MusicaActiva)
	{
	    new cancion = Variar(0, (MAX_CANCIONES-1));
	    if(cancion == 0)
	    {
	        PlayAudioStreamForPlayer(playerid, PrimeraCancion); //Si el random es 0 Entonces reproduce la primera sin numero.
	    }
	    else //Si no.. reproduce cualquier otra...
	    {
	        new string[150];
	        format(string, sizeof(string), Link, cancion);
		PlayAudioStreamForPlayer(playerid, string);
	    }
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	Sonido[playerid] = 0;
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(Sonido[playerid] == 1)
	{
	    StopAudioStreamForPlayer(playerid);
	    Sonido[playerid] = 0;
	}
	return 1;
}


public OnPlayerCommandText(playerid, cmdtext[])
{
	if(strcmp("/actmusica", cmdtext, true, 10) == 0)
	{
		if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COL_ROJO, "No eres RCON Admin.");
		else
		{
		    if(MusicaActiva)
		    {
		        MusicaActiva = false;
		        return SendClientMessage(playerid, COL_ROJO, "Desactivaste la musica al inicio del servidor.");
		    }
		    if(!MusicaActiva)
		    {
		        MusicaActiva = true;
		        return SendClientMessage(playerid, COL_ROJO, "Activaste la musica al inicio del servidor.");
		    }
		}
		return 1;
	}
	return 0;
}
