class MarathonActor : Actor
{
    bool friendlyHud;
    property friendlyHud : friendlyHud;

    bool invisibleHud;
    property invisibleHud : invisibleHud;

    bool hurtByLava;
    property hurtByLava : hurtByLava;

    int preferredFloatHeight;
    property preferredFloatHeight : preferredFloatHeight;

    Vector3 lastPos;
    Vector3 velocity;
    double hudOpacity;
    bool show;
    int timeout;

    bool disableFloat;
    int disableTicks;

    override void BeginPlay()
    {
        super.BeginPlay();
        lastPos = (pos.x, pos.y, pos.z);
        velocity = (0, 0, 0);
        hudOpacity = 0;
        timeout = 0;
        disableFloat = false;
        disableTicks = 0;
    }

    override void Tick()
    {
        super.Tick();

        //HUD
        velocity = (pos.x - lastPos.x, pos.y - lastPos.y, pos.z - lastPos.z);
        lastPos = (pos.x, pos.y, pos.z);

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

        //lava damage
        if(hurtByLava && pos.z == floorz)
        {
            let tex = TexMan.GetName(self.FloorPic);
            if(tex == "1SET19" || tex == "2SET12" || tex == "4SET05")
            {
                DamageMobj(self, self, 999, "Fire");
            }
        }

        //float height
        if(bFloat && !disableFloat)
        {
            double targetHeight = floorz + preferredFloatHeight;

            if (pos.z < targetHeight - 8) // Allow for a small buffer to prevent jittering
            {
                vel.z += 2.0; // Move up
            }
            else if (pos.z > targetHeight + 8)
            {
                vel.z = -2.0; // Move down
            }
            else{
                vel.z = 0;
            }

            if(target)
            {
                FLineTraceData h; //Save LineTrace data to this variable

                LineTrace(AngleTo(target), radius * 2, 0, TRF_THRUACTORS, 0, data:h); //Trace a line aimed at the target

                if(h.HitType == TRACE_HitWall && vel.x == 0 && vel.y == 0)
                {
                    //Console.Printf("Disable");
                    disableFloat = true;
                }
            }
        }   

        if(disableFloat)
        {
            disableTicks++;
            if(vel.x != 0 || vel.y != 0 || disableTicks > 200)
            {
                disableFloat = false;
                disableTicks = 0;
                //Console.Printf("Enable");
            }
        }

        // if(GetClassName() == "Fighter1"){
        //     ThinkerIterator it = ThinkerIterator.Create("PlatformThinker");
        //     PlatformThinker p = null;
        //     while (p = PlatformThinker(it.next()))
        //     {
        //         if(p.tagId == 6){
        //         let pos = PosRelative(p.sector);
        //         let x = pos.x - p.sector.centerspot.x;
        //         let y = pos.y - p.sector.centerspot.y;
        //         let dist = sqrt(x * x + y * y);
        //         if(dist < 64){
        //             p.Activate();
        //         }
        //         Console.Printf("PlatformThinker %d", dist);
        //         }
        //     }
        // }
    }


    // override void Die(Actor source, Actor inflictor, int dmgflags)
    // {
    //     lastDamageSource = inflictor.GetClassName();
    //     Super.Die(source, inflictor, dmgflags);
    // }

    void RemoveOnLava()
    {
        let tex = TexMan.GetName(self.FloorPic);
        // Console.Printf("%s", tex);
        if(tex == "1SET19" || tex == "2SET12" || tex == "4SET05")
        {
            A_SetRenderStyle(1, STYLE_None);
        }
    }
      
    Actor FindClosestTarget(string className)
    {
        PlayerPawn p = Players[consoleplayer].mo;
        
        Actor closest = p;
        double closestDist = Distance3D(p); //Start with distance to player
        let it = ThinkerIterator.Create(className);
        Actor a = null;
        while (a = Actor(it.next()))
        {
            if(a.health <= 0) { continue; }
            double dist = Distance3D(a);
            //a bob is closer. Target him
            if (dist < closestDist)
            {
                closestDist = dist;
                closest = a;
            }
        }
        return closest;
    }

    void TargetBobs()
    {
        let t = FindClosestTarget("Bob1");
        //Console.Printf("Targeting %s", t.GetClassName());
        if(t != null)
        {
            A_ClearTarget();
            target = t;
        }
    }
}