// Draws an image (qrcode in this casse) to the center of the screen 
// remove it after a few seconds
//
class JuggernautExplosion : EventHandler
{
    int timeout;
    bool show;
    float intensity;

    override void WorldTick()	// PLAY scope
    {
        if(show)
        {
            timeout++;
            intensity = 1.0 - (timeout / 80.0);
            if(timeout > 80)
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
        timeout = 0;
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
    int timeout;
    bool show;
    float intensity;

    string colour;
    float opacity;

    override void WorldTick()	// PLAY scope
    {
        if(show)
        {
            timeout++;
            intensity = 1.0 - (timeout / 32.0);
            if(timeout > 32)
            {
                show = false;
            }
        }
    }

    override void WorldThingDamaged(WorldEvent e)
    {
        if(e.Thing.GetClassName() != "MarathonPlayer")
        {
            return;
        }

        let inflictorClass = '';
        if(e.Inflictor != null)
        {
            inflictorClass = e.Inflictor.GetClassName();
        }

        opacity = 0.5;
        colour = "#FF0000";
        
        Console.Printf("%s", inflictorClass);
        if(inflictorClass == "FighterProjectile" || inflictorClass == "Fighter1" || inflictorClass == "Fighter2" || inflictorClass == "Fighter3" || inflictorClass == "Fighter4")
        {
            colour = "00FFFF";
        }
        else if(inflictorClass == "HunterShot")
        {
            colour = "#FF00FF";
        }
        else if(inflictorClass == "CompilerBall")
        {
            colour = "#00FF00";
        }

        // if(e.Inflictor.GetClassName() == "FighterProjectile")
        show = true;
        timeout = 0;
    }

    // UI Scope: you cannot alter data here
    override void renderOverlay(RenderEvent e) 	// UI scope
    {
        /// if it has been more then 128 ticks stop drawing image
        if(!show) { return; }
        Screen.Dim( colour, intensity * opacity, -Screen.GetWidth() * 2, -Screen.GetHeight() * 2, Screen.GetWidth() * 5, Screen.GetHeight() * 5); // Draw a white rectangle
    }
}