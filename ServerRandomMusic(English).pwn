//Login Random Music by Alterego (D.Z.) (DvdZvl)
/*

In order to this filterscript works, you'll need a web host

 Example:
 You must save the songs to play with the name "song.mp3"
 if you want have 3 different songs you should start with "song.mp3", "song1.mp3", "song2.mp3" ...

*/

#include <a_samp>
#define COL_RED 0x9F0000FF

//Settings:

#define MAX_SONGS (3) //Here place the amount of songs that you will use.
new FirstSong[] = "http://www.example.com/music/song.mp3"; // Here you place the route of the first song.mp3 (this should not contain any number)
new Link[] = "http://www.example.com/music/song%i.mp3"; // Here it places the route where the songs are

//
new Sound[MAX_PLAYERS];
new bool:MusicAct = true;

#define FILTERSCRIPT
#if defined FILTERSCRIPT
	public OnFilterScriptInit()
	{
		print(" Music at the start of your server - Ready.");
		return 1;
	}
	public OnFilterScriptExit()
	{
		return 1;
	}
	#else
	main()
	{
		print(" Music at the start of your server - Error (define filterscript).");
	}
#endif

CleanScreen(playerid)
{
	for(new i = 0; i < 10; i++) { SendClientMessage(playerid, -1, ""); }
	return 1;
}

Mixer(num1, num2)
{
new num = random(num2 - num1) + num1;
return num;
}

public OnPlayerConnect(playerid)
{
	Sound[playerid] = 1;
	if(MusicAct)
	{
	    new SONG = Mixer(0, (MAX_SONGS-1));
	    if(SONG == 0)
	    {
	        PlayAudioStreamForPlayer(playerid, FirstSong); //If the random is 0 then it reproduces the first song without a number.
			CleanScreen(playerid); // Clean the screen, so the link wont be visible
	    }
	    else //If not ... reproduce any other ...
	    {
	        new string[150];
	        format(string, sizeof(string), Link, SONG);
			PlayAudioStreamForPlayer(playerid, string);
			CleanScreen(playerid); // Clean the screen, so the link wont be visible
	    }
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	Sound[playerid] = 0;
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(Sound[playerid] == 1)
	{
	    StopAudioStreamForPlayer(playerid);
	    Sound[playerid] = 0;
	}
	return 1;
}


public OnPlayerCommandText(playerid, cmdtext[])
{
	if(strcmp("/activatemusic", cmdtext, true, 10) == 0)
	{
		if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COL_RED, "Server : Log in like RCON Admin to use this cmd.");
		else
		{
		    if(MusicAct)
		    {
		        MusicAct = false;
		        return SendClientMessage(playerid, COL_RED, "Server : You deactivated the music at the beginning of the server.");
		    }
		    if(!MusicAct)
		    {
		        MusicAct = true;
		        return SendClientMessage(playerid, COL_RED, "Server : You activated the music at the beginning of the server.");
		    }
		}
		return 1;
	}
	return 0;
}
