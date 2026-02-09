// Witcher Online Party Manager
// Handles party state and commands

class WOPartyManager
{
    private var partyName : string;

    public function Init()
    {
        partyName = "";
    }

    public function SetPartyName(name : string)
    {
        partyName = name;
        theGame.GetGuiManager().ShowNotification("Party changed to: " + partyName);
        theGame.r_getMultiplayerClient().UpdatePartyUI();
    }

    public function GetPartyName() : string
    {
        return partyName;
    }

    public function IsInParty() : bool
    {
        return StrLen(partyName) > 0;
    }

    public function LeaveParty()
    {
        partyName = "";
        theGame.GetGuiManager().ShowNotification("Left party.");
        theGame.r_getMultiplayerClient().UpdatePartyUI();
    }
}

exec function createparty(name : string)
{
    if(StrLen(name) > 0)
    {
        theGame.r_getMultiplayerClient().partyManager.SetPartyName(name);
        theGame.GetGuiManager().ShowNotification("Party Created: " + name);
    }
    else
    {
        theGame.GetGuiManager().ShowNotification("Usage: createparty <name>");
    }
}

exec function joinparty(name : string)
{
    if(StrLen(name) > 0)
    {
        theGame.r_getMultiplayerClient().partyManager.SetPartyName(name);
        theGame.GetGuiManager().ShowNotification("Joined Party: " + name);
    }
    else
    {
        theGame.GetGuiManager().ShowNotification("Usage: joinparty <name>");
    }
}

exec function leaveparty()
{
    theGame.r_getMultiplayerClient().partyManager.LeaveParty();
}

exec function party()
{
    var name : string;
    name = theGame.r_getMultiplayerClient().partyManager.GetPartyName();
    
    if(StrLen(name) > 0)
    {
        theGame.GetGuiManager().ShowNotification("Current Party: " + name);
    }
    else
    {
        theGame.GetGuiManager().ShowNotification("You are not in a party.");
    }
}
