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

class ProjectileFlyby : EventHandler
{
  int timeout;
  bool show;
  float intensity;

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
    if(e.Inflictor.GetClass() == "FighterProjectile")
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
    Screen.Dim("#00FFFF", intensity * 0.4, -Screen.GetWidth() * 2, -Screen.GetHeight() * 2, Screen.GetWidth() * 5, Screen.GetHeight() * 5); // Draw a white rectangle
  }
}