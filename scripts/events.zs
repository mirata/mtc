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