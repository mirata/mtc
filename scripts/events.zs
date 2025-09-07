// Draws an image (qrcode in this casse) to the center of the screen 
// remove it after a few seconds
//
class JuggernautExplosion : EventHandler
{
    int ticks;
    bool show;
    float intensity;

    override void WorldTick()	// PLAY scope
    {
        if(show)
        {
            ticks++;
            intensity = 1.0 - (ticks / 80.0);
            if(ticks > 80)
            {
                show = false;
            }
        }
    }

    override void WorldThingDestroyed(WorldEvent e)
    {
        if (e.Thing.GetClass() == "Juggernaut")
        {
        show = true;
        ticks = 0;
        }
    }

    // UI Scope: you cannot alter data here
    override void renderOverlay(RenderEvent e) 	// UI scope
    {
        /// if it has been more then 128 ticks stop drawing image
        if(!show) { return; }
        Screen.Dim("#FFF", intensity, -Screen.GetWidth() * 2, -Screen.GetHeight() * 2, Screen.GetWidth() * 5, Screen.GetHeight() * 5); // Draw a white rectangle
    }
}

class DamageOverlay : EventHandler
{
    int ticks;
    bool show;
    float intensity;

    string colour;
    float opacity;

    override void WorldTick()	// PLAY scope
    {
        if(show)
        {
            ticks++;
            intensity = 1.0 - (ticks / 32.0);
            if(ticks > 32)
            {
                show = false;
            }
        }
    }

    override void WorldThingDamaged(WorldEvent e)
    {
        let inflictorClass = '';
        let actorClass = '';
        let damageType = e.DamageType;
        if(e.Inflictor != null)
        {
            inflictorClass = e.Inflictor.GetClassName();
        }
        if(e.DamageSource != null)
        {
            actorClass = e.DamageSource.GetClassName();
        }

        Console.Printf("Damaged: %s, %s, %s", inflictorClass, actorClass, e.DamageType);
        
        //this is most likely sector damage
        if(inflictorClass == '' && actorClass == '')
        {
            opacity = 0.5;
            if(damageType == "Fire")
            {
                colour = "#FF6600";   
            }
            else if(damageType == "Slime")
            {
                colour = "#00FF00";
            }
        }
        else 
        {
            if(e.Thing.GetClassName() != "MarathonPlayer")
            {
                return;
            }

            opacity = 0.5;
            colour = "#FF0000";
            
            if(damageType == "Staff")
            {
                colour = "00FFFF";
            }
            else if(inflictorClass == "HunterShot" || inflictorClass == "SpitBall" || inflictorClass == "AlienPuff")
            {
                colour = "#FF00FF";
            }
            else if(inflictorClass == "CompilerBall")
            {
                colour = "#00FF00";
            }
        }

        show = true;
        ticks = 0;
    }

    // UI Scope: you cannot alter data here
    override void renderOverlay(RenderEvent e) 	// UI scope
    {
        if(!show) { return; }

        Screen.Dim( colour, intensity * opacity, -Screen.GetWidth() * 2, -Screen.GetHeight() * 2, Screen.GetWidth() * 5, Screen.GetHeight() * 5); // Draw a white rectangle
    }
}

class TeleportOverlay : EventHandler
{
    int ticks;
    bool show;
    float intensity;

    override void WorldTick()	// PLAY scope
    {
        if(show)
        {
            ticks++;
            //intensity should ramp from 0 to 1.0 at 15 ticks, then back down to 0.0 at 30 ticks
            intensity = ticks < 15 ? (ticks / 15.0) : (1.0 - ((ticks - 15) / 15.0));
            if(ticks > 30)
            {
                show = false;
            }
        }
    }

    override void WorldThingSpawned(WorldEvent e)
    {
        if (e.Thing.GetClass() == "MarathonTeleport")
        {
            show = true;
            ticks = 0;
        }
    }

    // UI Scope: you cannot alter data here
    override void renderOverlay(RenderEvent e) 	// UI scope
    {
        
		// Screen.DrawTexture(tex, true, 100, 100, DTA_CleanTop, true);

        // screen.DrawTexture (tex, true,
		// 				100,
		// 				100,
		// 				DTA_CleanNoMove, true,
		// 				DTA_LeftOffset, 0,
		// 				DTA_TopOffset, 0);
        /// if it has been more then 128 ticks stop drawing image

        // Screen.DrawTexture(tex, true, x-10, y,
		// 			DTA_KeepRatio, true,
		// 			DTA_VirtualWidth, hudwidth, DTA_VirtualHeight, hudheight, DTA_Alpha, 0.4);
        // TextureID tex = TexMan.CheckForTexture("TFOGA0", TexMan.Type_Any);
        // Console.Printf("%f", intensity);
        // if(intensity < float(0.2)){
        //     tex = TexMan.CheckForTexture("TFOGA0", TexMan.Type_Any);
        // }
        // else if(intensity < float(0.4)){
        //     tex = TexMan.CheckForTexture("TFOGB0", TexMan.Type_Any);
        // }
        // else if(intensity < float(0.6)){
        //     tex = TexMan.CheckForTexture("TFOGC0", TexMan.Type_Any);
        // }
        // else if(intensity < float(0.8)){
        //     tex = TexMan.CheckForTexture("TFOGD0", TexMan.Type_Any);
        // }


        // Screen.DrawTexture(tex, false, 0, 0, DTA_FullscreenEx, FSMode_ScaleToFit43, DTA_Masked, true);

        /// if it has been more then 128 ticks stop drawing image
        if(!show) { return; }
        Screen.Dim("#FFF", intensity, -Screen.GetWidth() * 2, -Screen.GetHeight() * 2, Screen.GetWidth() * 5, Screen.GetHeight() * 5); // Draw a white rectangle
    }
}

class VacuumHandler : EventHandler
{    
    PlayerPawn player;
    bool isVacuum;
    bool playedSound;

    int ticks;

    override void WorldLoaded(WorldEvent e) {
        isVacuum = level.airsupply == 0;
        playedSound = false;
        ticks = 0;

        for (int i = 0; i < Players.size(); i++) {
            self.player = PlayerPawn(Players[i].mo);
            if (self.player != null) {
                break; // Take the first valid player
            }
        }
    }

    override void WorldTick()
    {
        if(isVacuum) {
            int oxygenCount = player.CountInv("OxygenTank");
            Console.Printf("Oxygen count: %d", oxygenCount);

            if(ticks > 12) {
                player.TakeInventory("OxygenTank", 1);
                ticks = 0;
            }

            if(oxygenCount == 10 || oxygenCount == 50 || oxygenCount == 80){
                player.A_StartSound("AIRWARN", CHAN_BODY, CHANF_DEFAULT, 1);
            }

            Console.Printf("AirSupply: %d", level.airsupply);
            if(oxygenCount <= 0) {
                player.DamageMobj(null, null, 999, "Suffocation");
                if(!playedSound) {
                    player.A_StartSound("UUUGH", CHAN_BODY, CHANF_DEFAULT, 1);
                    playedSound = true;
                }
            }

            ticks++;
        }
    }
}