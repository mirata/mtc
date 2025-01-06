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

    override void BeginPlay()
    {
        super.BeginPlay();
        lastPos = (pos.x, pos.y, pos.z);
        velocity = (0, 0, 0);
        hudOpacity = 0;
        timeout = 0;
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
        if(bFloat)
        {
            double targetHeight = floorz + preferredFloatHeight;

            // Adjust the monster's Z velocity to move toward the target height
            // if(GetClassName() == "Compiler1")
            // {
            //     Console.Printf("%d, %d", pos.x, pos.y);
            // }
                if (pos.z < targetHeight - 8) // Allow for a small buffer to prevent jittering
                {
                    vel.z += 2.0; // Move up
                }
                else if (pos.z > targetHeight + 8)
                {
                    vel.z = -2.0; // Move down
                }

            // if (target != null)
            // {
            //     // Get the difference in height between the monster and the player
            //     double heightDifference = target.pos.z - pos.z;
            //     double groundOffset = pos.z - floorz;

            //     // If the target is below, dont hover offthe ground. Drop down
            //     if (heightDifference < 0 && groundOffset > 0)
            //     {
            //         vel.z = -2.0; // Adjust upwards velocity
            //     }
            //     // else if(heightDifference > 0 && groundOffset == 0)
            //     // {
            //     //     vel.z = 2.0; // Adjust downwards velocity
            //     // }
            //     else
            //     {
            //         vel.z = 0; // Maintain height
            //     }
            // }
        }
        
    }
      
    Actor FindClosestTarget(string className)
    {;
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