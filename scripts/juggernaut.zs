class Juggernaut : MarathonActor
{
    Default
    {
        //marathon scale factor 14
        //$Title "Juggernaut"
        //$Angled
        //$Category "Marathon Monsters"
        MarathonActor.preferredFloatHeight 64;
        MONSTER;
        +NOSPLASHALERT;
        +DONTGIB;
        +FLOAT;
        +NOGRAVITY;
        +DONTOVERLAP;
        +SPAWNFLOAT;
        +FLOORCLIP;
        obituary "%o was nuked by a Juggernaut.";
        hitobituary "%o was nuked by a Juggernaut.";
        health 10;
        radius 64;
        height 128;
        mass 100;
        speed 7;
        PainChance 0;
        attacksound "JUGASLT";
        seesound "";
        painsound "";
        deathsound "JUGWARN";
        activesound "";
        bloodcolor "ff ff 33";
        scale 0.875;
        //YScale 0.4;
    }

    States
    {
        Spawn:
            JUGG A -1;
            Stop;
        Spawn:
            JUGG A 6 A_Look;
            Loop;
        See:
            JUGG A 3 A_Chase;
            Loop;
        // Missile:
        //     JUGG A 0 A_Jump(32,"Missile2");
        //     JUGG A 2 A_FaceTarget;
        //     JUGG C 2 Bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
        //     JUGG B 2 Bright;
        //     JUGG C 2 Bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
        //     JUGG B 2 Bright;
        //     JUGG C 2 Bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
        //     JUGG B 2 Bright;
        //     JUGG C 2 Bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
        //     JUGG B 2 Bright;
        //     JUGG C 2 Bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
        //     JUGG B 2 Bright;
        //     JUGG C 2 Bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
        //     JUGG B 2 Bright;
        //     JUGG C 2 Bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
        //     JUGG B 2 Bright;
        //     JUGG C 2 Bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
        //     JUGG B 2 Bright;
        //     goto See;
        Missile:
            JUGG A 6 A_FaceTarget;
            JUGG A 0 Bright A_CustomMissile("JuggernautRocket", 4, -40, 15, CMF_OFFSETPITCH, 30);
            JUGG A 6 Bright A_CustomMissile("JuggernautRocket", 4, 40, -15, CMF_OFFSETPITCH, 30);
            Goto See;
        Death:
            JUGG A 0 A_NoGravity;
            JUGG A 0 A_NoBlocking;
            JUGG A 0 A_ChangeVelocity(0, 0, -0.7, CVF_REPLACE);
            JUGG D 30 BRIGHT A_Scream;
            Loop;
        Crash:
            JUGG A 0 A_StartSound("JUGDIE");
            TNT1 A 0 A_Explode(500, 512);
            Stop;
    }
}

class JuggernautRocket : Actor
{
    Default
    {
        Projectile;
        +FORCEXYBILLBOARD;
        +EXTREMEDEATH;
        -ROCKETTRAIL;
        -DEHEXPLOSION;
        -NOGRAVITY;
        +EXTREMEDEATH;
        +SEEKERMISSILE;
        -BOUNCEONFLOORS;
        -BOUNCEONWALLS;
        BounceType "None";
        Gravity 1;
        SeeSound "JUGFIRE";
        DeathSound "ASSAULT3";
        Radius 4;
        Height 8;
        Speed 10;
        DamageType "Normal";
        scale 0.75;
        //YScale 0.75;
        damage 15;
        Decal "Scorch";
    }

    bool isClose;
    double closeDistance;
    bool played;
    bool setVel;
    double turnRate;
    int ticks;

    override void BeginPlay()
    {
        turnRate = 1;
        ticks = 0;
    }

    override void Tick()
    {
        super.Tick();

        if (ticks > 15 && tracer != null && tracer.health > 0) // Ensure the target is alive
        {
            // Get current and target positions
            Vector3 currentPos = pos;
            Vector3 targetPos = tracer.pos;

            // Calculate the direction vector toward the target
            double deltaX = targetPos.X - currentPos.X;
            double deltaY = targetPos.Y - currentPos.Y;
            double deltaZ = targetPos.Z - currentPos.Z;

            // Calculate the desired yaw (horizontal angle)
            double desiredYaw = atan2(deltaY, deltaX);

            // Smoothly adjust the projectile's yaw toward the desired yaw
            double yawDiff = AngleDifference(angle, desiredYaw);
            angle += clamp(yawDiff, -turnRate, turnRate);

            // Calculate the desired pitch (vertical angle)
            double horizontalDistance = sqrt(deltaX * deltaX + deltaY * deltaY); // 2D distance
            double desiredPitch = atan2(deltaZ, horizontalDistance);

            // Smoothly adjust the projectile's pitch toward the desired pitch
            double pitchDiff = AngleDifference(pitch, desiredPitch);
            pitch += clamp(pitchDiff, -turnRate, turnRate);

            // Update velocity based on the new angles
            double speed = vel.Length(); // Maintain the existing speed
            vel.X = cos(pitch) * cos(angle) * speed;
            vel.Y = cos(pitch) * sin(angle) * speed;
            vel.Z = sin(pitch) * speed;
        }

        PlayerPawn p = Players[consoleplayer].mo;
        double d = p.Distance3D(self);
        if(!isClose && d < 70)
        {
            isClose = true;
            closeDistance = d;
        } 
        else if(isClose && !played && d > closeDistance)
        {
            bool alive = InStateSequence(self.curState, self.ResolveState("Spawn"));
            //Console.Printf("Alive: %d", alive);
            if(alive) {
            S_StartSound("GRNFBY", 0, 0, 1, ATTN_NORM, 0.0, 0.0);
            played = true;
            }
        }

        ticks++;
    }

     // Helper function to calculate the shortest angular difference
    private double AngleDifference(double a, double b)
    {
        double diff = b - a;
        while (diff > 180) diff -= 360;
        while (diff < -180) diff += 360;
        return diff;
    }

    States
    {
        Spawn:
            JUGM A 1 Bright
            {
                //A_SeekerMissile(2, 4);
                A_SpawnItem("JuggernautRocketSmoke");
            }
            Loop;
        Death:
            JUGM A 0 A_NoGravity;
            JUGM A 1 Bright A_Explode(64,64);
            GREN BCDEFG 4 Bright;
            Stop;
    }
}


class JuggernautRocketSmoke : Actor
{
    Default
    {
        +NOGRAVITY;
        +FORCEXYBILLBOARD;
        scale 0.5;
        //YScale 0.5;
    }
    
    States
    {
        Spawn:
            TNT1 A 3;
            FLAM CD 1 Bright;
            SMKE ABCD 1 Bright;
            Stop;
    }
}