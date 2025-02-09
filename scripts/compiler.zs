class Compiler1 : MarathonActor
{
    Default
    {
        //marathon scale factor 5
        //$Title "Compiler"
        //$Angled
        //$Category "Marathon Monsters"

        MarathonActor.hurtByLava true;
        MarathonActor.preferredFloatHeight 0;
        MONSTER;
        +FLOAT;
        +NOGRAVITY;
        +NOSPLASHALERT;
        +DONTGIB;
        +NOBLOOD;
        obituary "%o was scrambled by a compiler.";
        health 100;
        radius 14;
        height 56;
        mass 400;
        speed 6;
        painchance 255;
        seesound "";
        painsound "COMPPAIN";
        deathsound "COMPDEAD";
        activesound "";
        attacksound "";
        damagefactor "fire", 0.0;
        scale 0.3125; //with proper scale it should probably be 0.375 vertical due to the vertical warp
        //YScale 0.375; 
    }

	States
	{
		Spawn:
			COMP A 3 A_Look;
			Loop;
		See:
            COMP A 0 TargetBobs();
			COMP AAABBB 3 A_Chase;
			Loop;
		Missile:
			COMP B 7 Bright A_FaceTarget;
			COMP C 7 Bright A_FaceTarget;
			COMP D 7 Bright A_CustomMissile("CompilerBall",42,0,0,8,0);
			COMP C 7 Bright A_FaceTarget;
			goto See;
		Pain:
			COMP L 3 Bright A_Pain;
			goto See;
		Death:
			COMP L 4 Bright A_NoGravity;
			CFOG A 4 Bright A_Scream;
			CFOG BCD 4 Bright;
			Stop;
	}
}
class Compiler2 : Compiler1
{
    Default
    {
        //$Title "Compiler Major"
        health 150;
        Translation "CompilerMajor";
    }
    States
    {
        Pain:
            TNT1 A 0 A_SetTranslation("");
            COMP L 3 Bright A_Pain;
            TNT1 A 0 A_SetTranslation("CompilerMajor");
            goto See;
        Death:
            TNT1 A 0 A_NoGravity;
            TNT1 A 0 A_SetTranslation("");
            CFOG A 4 Bright A_Scream;
            CFOG BCD 4 Bright;
            Stop;
        Missile:
            COMP C 7 Bright A_FaceTarget;
            COMP D 7 Bright A_CustomMissile("Compilerball2",42,0,0,8,0);
            COMP C 7 Bright A_FaceTarget;
            goto See;
    }
}

class Compiler3 : Compiler1
{
    Default
    {
        //$Title "Compiler Stealth"
        MarathonActor.invisibleHud true;
        Translation "Shadow";
        RenderStyle "STYLE_Translucent";
        alpha 0.25;
        obituary "%o thought he saw a compiler.";
    }
    States
    {
        Pain:
            TNT1 A 0 A_SetTranslation("");
            TNT1 A 0 A_SetRenderStyle(1, STYLE_Normal);
            COMP L 3 Bright A_Pain;
            TNT1 A 0 A_SetTranslation("Shadow");
            TNT1 A 0 A_SetRenderStyle(0.25, STYLE_Translucent);
            goto See;
        Death:
            TNT1 A 0 A_NoGravity;
            TNT1 A 0 A_SetTranslation("");
            TNT1 A 0 A_SetRenderStyle(1, STYLE_Normal);
            CFOG A 4 Bright A_Scream;
            CFOG BCD 4 Bright;
            Stop;
    }
}

class Compiler4 : Compiler2
{
    Default
    {
        //$Title "Compiler Stealth Major"
        MarathonActor.invisibleHud true;
        Translation "Shadow";
        RenderStyle "STYLE_Translucent";
        alpha 0.25;
        obituary "%o thought he saw a compiler.";
    }
    States
    {
        Pain:
            TNT1 A 0 A_SetTranslation("");
            TNT1 A 0 A_SetRenderStyle(1, STYLE_Normal);
            COMP L 3 Bright A_Pain;
            TNT1 A 0 A_SetTranslation("Shadow");
            TNT1 A 0 A_SetRenderStyle(0.25, STYLE_Translucent);
            goto See;
        Death:
            TNT1 A 0 A_NoGravity;
            TNT1 A 0 A_SetTranslation("");
            TNT1 A 0 A_SetRenderStyle(1, STYLE_Normal);
            CFOG A 4 Bright A_Scream;
            CFOG BCD 4 Bright;
            Stop;
    }
}

class CompilerBall : Actor
{
    Default
    {
        +FORCEXYBILLBOARD;
        Radius 6;
        Height 10;
        Speed 8;
        FastSpeed 16;
        Damage 4;
        Projectile;
        SeeSound "COMPATK1";
        DeathSound "COMPATK2";
        Decal "PlasmaScorchLower";
        scale 0.5;
        //YScale 0.5;
    }

  bool isClose;
  double closeDistance;
  bool played;

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
                S_StartSound("COMPFBY", 0, 0, 1, ATTN_NORM, 0.0, 0.0);
                played = true;
            }
        }
    }

    States
    {
        Spawn:
            COMP EEEEFFFF 1 Bright A_SpawnItem("CompilerBallTrail");
            Loop;
        Death:
            COMP JK 6 Bright;
            Stop;
    }
}

class CompilerBallTrail : Actor
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
            COMP GHI 1 Bright;
            Stop;
    }
}

class CompilerBall2 : CompilerBall
{
  Default
    {
        +SEEKERMISSILE;
        Translation "112:127=160:167";
    }
    States
    {
        Spawn:
            COMP E 1 Bright A_SeekerMissile(2,2);
            COMP E 0 Bright A_SpawnItem("CompilerBallTrail2");
            COMP E 1 Bright A_SeekerMissile(2,2);
            COMP E 0 Bright A_SpawnItem("CompilerBallTrail2");
            COMP E 1 Bright A_SeekerMissile(2,2);
            COMP E 0 Bright A_SpawnItem("CompilerBallTrail2");
            COMP E 1 Bright A_SeekerMissile(2,2);
            COMP E 0 Bright A_SpawnItem("CompilerBallTrail2");
            COMP F 1 Bright A_SeekerMissile(2,2);
            COMP F 0 Bright A_SpawnItem("CompilerBallTrail2");
            COMP F 1 Bright A_SeekerMissile(2,2);
            COMP F 0 Bright A_SpawnItem("CompilerBallTrail2");
            COMP F 1 Bright A_SeekerMissile(2,2);
            COMP F 0 Bright A_SpawnItem("CompilerBallTrail2");
            COMP F 1 Bright A_SeekerMissile(2,2);
            COMP F 0 Bright A_SpawnItem("CompilerBallTrail2");
            Loop;
        Death:
            COMP JK 6 Bright;
            Stop;
    }
}

class CompilerBallTrail2 : CompilerBallTrail
{
    Default
    {
        Translation "112:127=160:167";
    }
}