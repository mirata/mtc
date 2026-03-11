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

    bool cooldown;
    int cooldownTicks;
    int cooldownTimeout;
    property cooldownTimeout : cooldownTimeout;

    Vector3 lastPos;
    Vector3 velocity;
    double hudOpacity;
    bool show;
    int timeout;

    float prevz;
    bool isStable;
    int stableTicks;
    bool moveToFloatHeight;

    bool isFloatingActor;

    override void BeginPlay()
    {
        super.BeginPlay();
        isFloatingActor = bFloat;
        lastPos = (pos.x, pos.y, pos.z);
        velocity = (0, 0, 0);
        hudOpacity = 0;
        timeout = 0;

        prevz = pos.z;
        isStable = true;
        stableTicks = 0;
        moveToFloatHeight = false;

        cooldown = false;
        cooldownTicks = 0;
        if(cooldownTimeout == 0) {
            cooldownTimeout = 45; //Default cooldown timeout
        }
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

        double targetFloor = floorz;

        // 3D floors: if we're above a 3D floor, treat the highest such floor under us
        // as the effective minimum floor for float-height logic.
        let curSec = Level.PointInSector((pos.x, pos.y));
        if (curSec != null && curSec.Get3DFloorCount() > 0)
        {
            double fz;
            Sector fsec;
            F3DFloor ff;
            // Query slightly above our current Z so the floor we're standing on counts.
            [fz, fsec, ff] = curSec.NextLowestFloorAt(pos.x, pos.y, pos.z + 1.0);
            targetFloor = max(targetFloor, fz);
        }
        // if(target)
        // {
        //     targetFloor = target.floorz;
        //     FLineTraceData h;

        //     LineTrace(AngleTo(target), radius * 2, 0, TRF_THRUACTORS, 0, data: h); //Trace a line aimed at the target

        //     if(h.HitType == TRACE_HitWall)
        //     {
        //         //Console.Printf("Hit, %d, %d", h.HitSector != null ? h.HitSector.GetTag(0) : -1, h.LinePart);
        //         if(h.HitLine != null) {
        //             let front = h.HitLine.frontsector;
        //             let back = h.HitLine.backsector;
        //             if(front != null && back != null) {
        //                 if(front != null && front != h.HitSector) {
        //                     targetFloor = -front.floorplane.d;
        //                 };
        //                 if(back != null && back != h.HitSector) {
        //                     targetFloor = -back.floorplane.d;
        //                 };
        //             }
        //         }
        //         Console.Printf("target floor: %f, %f", pos.z, targetFloor);
        //     }
        // }

        //float height
        if(isFloatingActor)
        {        
            if(health <= 0) {
                bFloat = false; 
            } else{        
                let dz = pos.z - prevz;
                if(!isStable && dz == 0) {
                    isStable = true;
                    stableTicks = 0;
                    // Console.Printf("Stable");
                }
                if(isStable && dz != 0) {
                    isStable = false;
                    stableTicks = 0;
                    // Console.Printf("Unstable");
                }
                if(isStable) {
                    stableTicks++;
                }
                if(stableTicks > 35) {
                    moveToFloatHeight = true;
                    // Console.Printf("moveToFloatHeight");
                }

                if(moveToFloatHeight) {
                    double targetHeight = targetFloor + preferredFloatHeight;

                    // Console.Printf("target floor: %f, %f", pos.z, targetHeight);
                    if (pos.z < targetHeight) // Allow for a small buffer to prevent jittering
                    {
                        // Console.Printf("Moving up");
                        vel.z = 2.0; // Move up
                    }
                    else if (pos.z > targetHeight)
                    {
                        bFloat = false; // Disable native floating
                        // Console.Printf("Moving down");
                        vel.z = -2.0; // Move down
                    }
                    else{
                        //Console.Printf("Done");
                        moveToFloatHeight = false;
                        vel.z = 0;
                        bFloat = true; 
                    }
                }
            }
        }

        if(cooldown)
        {
            cooldownTicks++;
            // Console.Printf("Cooldown");
            if (cooldownTicks >= cooldownTimeout)
            {
                cooldown = false;
                cooldownTicks = 0;
                // Console.Printf("Cooldown ended");
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

        prevz = pos.z;
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

    void TargetPlayerAllies()
    {
        let t = FindClosestTarget("MarathonAlly");
        //Console.Printf("Targeting %s", t.GetClassName());
        if(t != null)
        {
            A_ClearTarget();
            target = t;
        }
    }
}

class MarathonAlly : MarathonActor
{
    Default
    {
        MarathonActor.friendlyHud true;
    }
}