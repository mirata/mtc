class Juggernaut : MarathonActor
{
    Default
    {
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
        painchance 0;
        seesound "";
        painsound "";
        deathsound "JUGWARN";
        activesound "";
        bloodcolor "ff ff 33";
        scale 0.9;
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
        Missile:
            JUGG A 1 A_Jump(32,"Missile2");
            JUGG A 2 A_FaceTarget;
            JUGG A 2 bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
            JUGG A 2;
            JUGG A 2 bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
            JUGG A 2;
            JUGG A 2 bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
            JUGG A 2;
            JUGG A 2 bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
            JUGG A 2;
            JUGG A 2 bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
            JUGG A 2;
            JUGG A 2 bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
            JUGG A 2;
            JUGG A 2 bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
            JUGG A 2;
            JUGG A 2 bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
            JUGG A 2;
            goto See;
        Missile2:
            JUGG A 6 A_FaceTarget;
            JUGG A 0 Bright A_CustomMissile("JuggernautRocket", 4, -40, random(-1,1), 8, random(-1,1));
            JUGG A 6 Bright A_CustomMissile("JuggernautRocket", 4, 40, random(-1,1), 8, random(-1,1));
            Goto See;
        Death:
            JUGG A 0 A_NoGravity;
            JUGG A 0 A_NoBlocking;
            JUGG A 0 A_ChangeVelocity(0, 0, -0.7, CVF_REPLACE);
            JUGG D 30 A_Scream;
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
        Gravity 1;
        SeeSound "JUGFIRE";
        DeathSound "ASSAULT3";
        Radius 4;
        Height 8;
        Speed 10;
        DamageType "Normal";
        scale .75;
        //YScale 0.75;
        damage 15;
        Decal "Scorch";
    }

    bool isClose;
    double closeDistance;
    bool played;
    bool setVel;

    override void Tick()
    {
        super.Tick();

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
    }

    States
    {
        Spawn:
            GREN A 1 Bright
            {
                A_SeekerMissile(2, 4);
                A_SpawnItem("JuggernautRocketSmoke");

                if(!setVel)
                {
                    A_ChangeVelocity(0, 0, 6, CVF_RELATIVE);
                    setVel = true;
                }
            }
            Loop;
        Death:
            GREN A 0 A_NoGravity;
            GREN A 1 Bright A_Explode(64,64);
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
        scale .5;
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