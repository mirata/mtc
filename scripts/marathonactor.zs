class MarathonActor : Actor
{
    bool friendlyHud;
    property friendlyHud : friendlyHud;

    bool invisibleHud;
    property invisibleHud : invisibleHud;

    Vector2 lastPos;
    Vector2 velocity;
    double hudOpacity;
    bool show;
    int timeout;

    override void BeginPlay()
    {
        super.BeginPlay();
        lastPos = (pos.x, pos.y);
        velocity = (0, 0);
        hudOpacity = 0;
        timeout = 0;
    }

    override void Tick()
    {
        super.Tick();
        velocity = (pos.x - lastPos.x, pos.y - lastPos.y);
        lastPos = (pos.x, pos.y);

        if(!invisibleHud)
        {
            if (velocity.x != 0 || velocity.y != 0)
            {
                show = true;
                hudOpacity = 1.0;
                timeout = 0;
            }
            else
            {
                if(show)
                {
                    timeout++;
                    hudOpacity = 1.0 - (timeout / 32.0);
                    if(timeout > 32)
                    {
                        show = false;
                    }
                }
            }
        }
    }
}