// Witcher Online Party UI
// Handles rendering of the party list

class WOPartyUI
{
    private var header : MP_SU_OnelinerScreen;
    private var memberLines : array<MP_SU_OnelinerScreen>;
    private var lastUpdate : float;

    public function Init()
    {
        lastUpdate = 0.0f;
        // Cleanup old UI if any
        Clear();
    }

    public function Clear()
    {
        var i : int;
        
        if(header)
        {
            MP_SUOL_getManager().deleteOneliner(header);
            header = NULL;
        }

        for(i = 0; i < memberLines.Size(); i+=1)
        {
            if(memberLines[i])
            {
                MP_SUOL_getManager().deleteOneliner(memberLines[i]);
            }
        }
        memberLines.Clear();
    }

    public function Update()
    {
        var partyName : string;
        var players : array<r_RemotePlayer>;
        var i : int;
        var yPos : float;
        var line : MP_SU_OnelinerScreen;
        var memberCount : int;

        partyName = theGame.r_getMultiplayerClient().partyManager.GetPartyName();

        // If not in a party, clear UI and return
        // If not in a party, check for pending invites
        if(StrLen(partyName) == 0)
        {
            partyName = theGame.r_getMultiplayerClient().partyManager.GetPendingInviteParty();
            if(StrLen(partyName) > 0)
            {
                // Show Invite UI
                Clear();
                
                // Header: INVITE RECEIVED
                header = new MP_SU_OnelinerScreen in theInput;
                header.text = (new MP_SUOL_TagBuilder in theInput)
                    .tag("font")
                    .attr("size", "24")
                    .attr("color", "#FFFF00") // Yellow
                    .text("INVITE RECEIVED");
                header.position = Vector(0.05, 0.2, 0); 
                header.visible = true;
                MP_SUOL_getManager().createOneliner(header);

                // Line 1: From Sender
                line = new MP_SU_OnelinerScreen in theInput;
                line.text = (new MP_SUOL_TagBuilder in theInput)
                    .tag("font")
                    .attr("size", "20")
                    .attr("color", "#FFFFFF")
                    .text("From: " + theGame.r_getMultiplayerClient().partyManager.GetPendingInviteSender());
                line.position = Vector(0.06, 0.25, 0);
                line.visible = true;
                MP_SUOL_getManager().createOneliner(line);
                memberLines.PushBack(line);

                // Line 2: To join Party
                line = new MP_SU_OnelinerScreen in theInput;
                line.text = (new MP_SUOL_TagBuilder in theInput)
                    .tag("font")
                    .attr("size", "20")
                    .attr("color", "#FFFFFF")
                    .text("Party: " + partyName);
                line.position = Vector(0.06, 0.29, 0);
                line.visible = true;
                MP_SUOL_getManager().createOneliner(line);
                memberLines.PushBack(line);

                // Line 3: Type /accept
                line = new MP_SU_OnelinerScreen in theInput;
                line.text = (new MP_SUOL_TagBuilder in theInput)
                    .tag("font")
                    .attr("size", "20")
                    .attr("color", "#00FF00") // Green
                    .text("Type /accept");
                line.position = Vector(0.06, 0.33, 0);
                line.visible = true;
                MP_SUOL_getManager().createOneliner(line);
                memberLines.PushBack(line);
                
                return;
            }

            Clear();
            return;
        }

        // Recreate UI (simple approach: clear and rebuild)
        // Optimization: Could reuse lines, but for now this ensures correctness.
        Clear();

        // Header
        header = new MP_SU_OnelinerScreen in theInput;
        header.text = (new MP_SUOL_TagBuilder in theInput)
            .tag("font")
            .attr("size", "24")
            .attr("color", "#5f90c6") // Blue-ish
            .text("Party: " + partyName);
        header.position = Vector(0.05, 0.2, 0); // X, Y, Z (Z unused for screen)
        header.visible = true;
        MP_SUOL_getManager().createOneliner(header);

        yPos = 0.25;
        memberCount = 0;

        // Add Self
        line = new MP_SU_OnelinerScreen in theInput;
        line.text = (new MP_SUOL_TagBuilder in theInput)
            .tag("font")
            .attr("size", "20")
            .attr("color", "#FFFFFF")
            .text(theGame.r_getMultiplayerClient().getUsername() + " (" + (int)RoundF((thePlayer.GetHealth() / thePlayer.GetStatMax(BCS_Vitality)) * 100) + "%)");
        line.position = Vector(0.06, yPos, 0);
        line.visible = true;
        MP_SUOL_getManager().createOneliner(line);
        memberLines.PushBack(line);
        
        yPos += 0.04;
        memberCount += 1;

        // Add Remote Players
        players = theGame.r_getMultiplayerClient().getGlobalPlayers();
        for(i = 0; i < players.Size(); i+=1)
        {
            if(players[i].partyName == partyName && StrLen(players[i].partyName) > 0)
            {
                line = new MP_SU_OnelinerScreen in theInput;
                line.text = (new MP_SUOL_TagBuilder in theInput)
                    .tag("font")
                    .attr("size", "20")
                    .attr("color", "#FFFFFF")
                    .attr("color", "#FFFFFF")
                    .text(players[i].username + " (" + players[i].healthPct + "%)");
                line.position = Vector(0.06, yPos, 0);
                line.visible = true;
                MP_SUOL_getManager().createOneliner(line);
                memberLines.PushBack(line);

                yPos += 0.04;
                memberCount += 1;
            }
        }
    }

    public function UpdateLoop()
    {
        var curTime : float;
        
        // Only update if we are in a party
        // Update if in party OR if pending invite exists
        if(StrLen(theGame.r_getMultiplayerClient().partyManager.GetPartyName()) == 0 && StrLen(theGame.r_getMultiplayerClient().partyManager.GetPendingInviteParty()) == 0)
        {
            return;
        }

        curTime = theGame.GetEngineTimeAsSeconds();
        if( (curTime - lastUpdate) > 1.0 )
        {
            Update();
            lastUpdate = curTime;
        }
    }
}
