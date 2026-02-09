// Witcher Online Party Manager
// Handles party state and commands

class WOPartyManager
{
    private var partyName : string;

    public function Init()
    {
        partyName = "";
    }

    public function SetPartyName(pName : string)
    {
        partyName = pName;
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

exec function createparty(partyNameStr : string)
{
    if(StrLen(partyNameStr) > 0)
    {
        theGame.r_getMultiplayerClient().partyManager.SetPartyName(partyNameStr);
        theGame.GetGuiManager().ShowNotification("Party Created: " + partyNameStr);
    }
    else
    {
        theGame.GetGuiManager().ShowNotification("Usage: createparty <name>");
    }
}

exec function joinparty(partyNameStr : string)
{
    if(StrLen(partyNameStr) > 0)
    {
        theGame.r_getMultiplayerClient().partyManager.SetPartyName(partyNameStr);
        theGame.GetGuiManager().ShowNotification("Joined Party: " + partyNameStr);
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
    var pName : string;
    pName = theGame.r_getMultiplayerClient().partyManager.GetPartyName();
    
    if(StrLen(pName) > 0)
    {
        theGame.GetGuiManager().ShowNotification("Current Party: " + pName);
    }
    else
    {
        theGame.GetGuiManager().ShowNotification("You are not in a party.");
    }
}
