class Wasp1 : MarathonActor
{
    Default
    {
        //marathon scale factor 4
        //$Title "Wasp"
        //$Angled
        //$Category "Marathon Monsters"
        MarathonActor.preferredFloatHeight 16;
        Monster;
        +FLOAT;
        +NOGRAVITY;
        +DONTOVERLAP;
        +MISSILEMORE;
        +SPAWNFLOAT;
        +NOSPLASHALERT;
        +DONTGIB;
        Health 16;
        Radius 13;
        Height 32;
        Mass 50;
        Speed 10;
        Painchance 200;
        bloodcolor "Purple";
        SeeSound "WASPSEE";
        AttackSound "WASPSPIT";
        PainSound "";
        DeathSound "WASPSEE";
        ActiveSound "WASPFLAP";
        Obituary "%o was poisoned by a wasp's venom.";
        HitObituary "%o was stung by a wasp.";
        scale 0.25;
        //YScale 0.25;
    }
  
    States
    {
        Spawn:
            TNT1 A 0
            {
                isFloatingActor = false;
            }
            // WASP A 0 A_StartSound("WASPFLAP");
            WASP A 6 A_Look;
            Loop;
        See:
            TNT1 A 0
            {
                isFloatingActor = true;
            }
            WASP A 0 TargetPlayerAllies();
            WASP A 0 A_StartSound("WASPFLAP");
            WASP AABBCCBB 3 A_Chase;
            Loop;
        FaceTarget:
            WASP AABBCCBB 3 A_FaceTarget;
            TNT1 A 0
            {
                if(!cooldown) {
                    SetStateLabel("See");
                }
            }
            Loop;
        Melee:
            TNT1 A 0
            {
                if(cooldown) {
                    SetStateLabel("FaceTarget");
                }
            }
            WASP DE 6 A_FaceTarget;
            // WASP F 6 A_CustomMeleeAttack(random(5,12),"WASPSPIT","WASPSPIT");
            Goto See;
        Missile:
            TNT1 A 0
            {
                if(cooldown) {
                    SetStateLabel("FaceTarget");
                }
            }
            WASP DE 6 A_FaceTarget;
            WASP F 6 A_CustomMissile("SpitBall",4,0,random(-1,1),8,random(-1,1));
            Goto See;
        Death:
            WASP A 0 A_Gravity;
            WASP M 0 A_NoBlocking;
            WASP M 5 A_Scream;
            WASP NOP 5;
            Loop;
        Crash:
            WASP Q 7 A_StartSound("SPLAT");
            WASP R 7;
            WASP S -1 RemoveOnLava;
            Stop;
    }

    override void Tick()
    {
        super.Tick();
        if(CurState == FindState('Spawn'))
        {
            Console.Printf("Wasp is in Spawn state");
        }
    }
}

class SpitBall : Actor
{
    Default
    {
        -ACTIVATEPCROSS;
        -ACTIVATEIMPACT;
        +SPAWNSOUNDSOURCE;
        Projectile;
        Radius 8;
        Height 8;
        Speed 10;
        FastSpeed 20;
        Damage 2;
        SeeSound "WASPSPIT";
        DeathSound "WASPHIT";
        scale 0.5;
        //YScale 0.5;
    }

    States
    {
        Spawn:
            WASP G 1;
            Loop;
        Death:
            WASP HIGJKL 5;
            Stop;
    }
}

class Wasp2 : Wasp1
{
    Default
    {
        //$Title "Wasp Major"
        +MISSILEEVENMORE;
        -MISSILEMORE;
        health 30;
        Translation "64:79=80:111", "176:191=112:127";
    }
}
class Wasp3 : Wasp1
{
    Default
    {
        //$Title "Wasp Boss"
        +MISSILEEVENMORE;
        health 60;
        Translation "64:79=48:79", "176:191=[161,0,100]:[0,0,0]";
    }
}