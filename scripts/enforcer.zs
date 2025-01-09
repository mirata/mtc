class Enforcer1 : MarathonActor
{
    Default
    {
        //$Title "Enforcer"
        //$Angled
        //$Category "Marathon Monsters"
        MarathonActor.hurtByLava true;
        MONSTER;
        +FLOORCLIP;
        +NOSPLASHALERT;
        +DONTGIB;
        obituary "%o was killed by an enforcer.";
        hitobituary "%o was smacked down by an enforcer.";
        health 25;
        radius 13;
        height 51;
        mass 100;
        speed 7;
        painchance 0;
        Translation "192:207=[0,176,201]:[0,14,15]", "168:191=[161,0,100]:[51,0,32]", "208:223=[237,215,20]:[54,49,7]";
        seesound "ENFWAKE";
        painsound "";
        attacksound "ALIENGUN";
        deathsound "";
        activesound "ENFWAKE";
        bloodcolor "ff ff 33";
        scale .3;
        //YScale 0.4;
    }

    override void Tick()
    {
        super.Tick();
        //   TargetBobs();
    }

    States
    {
        Spawn:
            ENFO B 10 A_Look;
            // TNT1 A 0 A_CheckLOF("See", CLOFF_JUMPENEMY|CLOFF_JUMPFRIEND|CLOFF_SKIPOBJECT|CLOFF_ALLOWNULL|CLOFF_SETTARGET, 8000, 0, 40, 0, 0, AAPTR_NULL);
            Loop;
        See:
            TNT1 A 0 TargetBobs();
            ENFO ABC 3 A_Chase;
            // TNT1 A 0 A_CheckLOF("See", CLOFF_JUMPENEMY|CLOFF_JUMPFRIEND|CLOFF_SKIPOBJECT|CLOFF_ALLOWNULL|CLOFF_SETTARGET, 8000, 0, 40, 0, 0, AAPTR_NULL);
            Loop;
        Missile:
            ENFO A 2 A_FaceTarget;
            ENFO D 2 bright A_CustomBulletAttack(6,0,1,3,"AlienPuff",0,0);
            ENFO A 3;
            ENFO D 2 bright A_CustomBulletAttack(6,0,1,3,"AlienPuff",0,0);
            ENFO A 3;
            ENFO D 2 bright A_CustomBulletAttack(6,0,1,3,"AlienPuff",0,0);
            ENFO A 3;
            ENFO D 2 bright A_CustomBulletAttack(6,0,1,3,"AlienPuff",0,0);
            ENFO A 10;
            goto See;
        Death:
            ENFO E 0 A_FaceTarget;
            ENFO E 8 A_Scream;
            ENFO E 1 A_CheckFloor("Death2");
            Wait;
        Death2:
            ENFO F 8 A_NoBlocking;
            ENFO F 1 A_CheckFloor("Death3");
            Wait;
        Death3:
            ENFO G 8;
            ENFO G 1 A_CheckFloor("Death4");
            Wait;
        Death4:
            ENFO H 1 A_StartSound("Splat");
            ENFO H -1 RemoveOnLava;
            Stop;
        Burn:
            TNT1 A 0 A_SetTranslation("");
            BURN A 5 Bright A_StartSound("PFHORBURN");
            BURN A 1 Bright A_CheckFloor("Burn2");
            Wait;
        Burn2:
            BURN B 5 Bright A_NoBlocking;
            BURN B 1 Bright A_CheckFloor("Burn3");
            Wait;
        Burn3:
            BURN C 5 Bright;
            BURN C 1 Bright A_CheckFloor("Burn4");
            Wait;
        Burn4:
            BURN D 5 Bright;
            BURN D 1 Bright A_CheckFloor("Burn5");
            Wait;
        Burn5:
            BURN E -1 RemoveOnLava;
            Stop;
        Death.LavaFire:
            TNT1 A 0 A_SetTranslation("");
            BURN A 0 Bright A_NoBlocking;
            BURN A 5 Bright A_StartSound("PFHORBURN");
            BURN A 1 Bright A_Checkfloor("Death.LavaFire1");
            Wait;
        Death.LavaFire1:
            BURN B 5 Bright;
            BURN B 1 Bright A_Checkfloor("Death.LavaFire2");
            Wait;
        Death.LavaFire2:
            BURN C 5 Bright;
            BURN C 1 Bright A_Checkfloor("Death.LavaFire3");
            Wait;
        Death.LavaFire3:
            BURN D 5 Bright;
            BURN D 1 Bright A_Checkfloor("Death.LavaFire4");
            Wait;
        Death.LavaFire4:
            BURN E -1 RemoveOnLava;
            Stop;
    }
}

class Enforcer2 : Enforcer1
{
    Default
    {
        //$Title "Enforcer Major"
        health 50;
        Translation "192:207=[57,228,139]:[2,15,8]", "168:191=[161,0,100]:[51,0,32]", "208:223=[237,215,20]:[54,49,7]";
    }
}