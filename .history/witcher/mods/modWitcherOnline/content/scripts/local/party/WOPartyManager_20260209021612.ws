// Witcher Online Party Manager
// Handles party state and commands

class WOPartyManager
{
    private var partyName : string;
    private var pendingInviteParty : string;
    private var pendingInviteSender : string;

    public function Init()
    {
        partyName = "";
        pendingInviteParty = "";
        pendingInviteSender = "";
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

    public function SendInvite(targetName : string)
    {
        var msg : string;
        
        if(!IsInParty())
        {
            theGame.GetGuiManager().ShowNotification("You must create a party first!");
            return;
        }

        if(StrLen(targetName) == 0)
        {
            theGame.GetGuiManager().ShowNotification("Usage: /invite <username>");
            return;
        }

        // Protocol: #INVITE:TargetName:PartyName
        msg = "#INVITE:" + targetName + ":" + partyName;
        
        // internal function to send chat (handled in client.ws usually via mpghosts_chat exec, but we need direct access)
        // We will use theGame.r_getMultiplayerClient().mpghosts_chat(msg) if available or just execute the command.
        // Direct access:
        theGame.r_getMultiplayerClient().setChat(msg);
        theGame.r_getMultiplayerClient().setLastChatTime(theGame.GetEngineTimeAsSeconds());
        
        theGame.GetGuiManager().ShowNotification("Invite sent to " + targetName);
    }

    public function ReceiveInvite(sender : string, pName : string)
    {
        if(IsInParty())
        {
            if(partyName == pName)
            {
                // Already in this party, ignore silently (prevents overwriting 'Joined' msg)
                return;
            }
            // Auto-decline or just ignore? Let's notify but warn.
            theGame.GetGuiManager().ShowNotification("Invite from " + sender + " to party '" + pName + "' ignored (Already in party).");
            return;
        }

        if(pendingInviteSender == sender && pendingInviteParty == pName)
        {
            // Already pending, don't spam notifications
            return;
        }

        pendingInviteSender = sender;
        pendingInviteParty = pName;

        theGame.GetGuiManager().ShowNotification("Party Invite received from " + sender + "!");
        theGame.GetGuiManager().ShowNotification("Type /accept to join '" + pName + "'");
    }

    public function AcceptInvite()
    {
        if(StrLen(pendingInviteParty) > 0)
        {
            SetPartyName(pendingInviteParty);
            theGame.GetGuiManager().ShowNotification("You joined " + pendingInviteParty);
            
            // Clear pending
            pendingInviteParty = "";
            pendingInviteSender = "";
        }
        else
        {
            theGame.GetGuiManager().ShowNotification("No pending invites.");
        }
    }

    public function DeclineInvite()
    {
        if(StrLen(pendingInviteParty) > 0)
        {
            theGame.GetGuiManager().ShowNotification("Declined invite to " + pendingInviteParty);
            pendingInviteParty = "";
            pendingInviteSender = "";
        }
        else
        {
            theGame.GetGuiManager().ShowNotification("No pending invites.");
        }
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

exec function invite(target : string)
{
    theGame.r_getMultiplayerClient().partyManager.SendInvite(target);
}

exec function accept()
{
    theGame.r_getMultiplayerClient().partyManager.AcceptInvite();
}

exec function decline()
{
    theGame.r_getMultiplayerClient().partyManager.DeclineInvite();
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
