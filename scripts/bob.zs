class Bob1 : MarathonActor
{
    Default
    {
        //marathon scale factor 8
        //$Title "Civilian Crew"
        //$Angled
        //$Category "Marathon Monsters"
        MarathonActor.friendlyHud true;
        MarathonActor.hurtByLava true;
        MONSTER;
        +FLOORCLIP;
        +FRIENDLY;
        +FRIGHTENED;
        -COUNTKILL;
        +DONTGIB;
        +NOSPLASHALERT;
        obituary "%o hacked the game.";
        health 20;
        radius 13;
        height 51;
        mass 100;
        speed 8;
        painchance 255;
        seesound "";
        attacksound "";
        painsound "PAIN";
        deathsound "PLAYERDIE";
        activesound "";
        scale .5;
        Translation "64:79=[149,76,46]:[31,19,19]", "112:127=[0,255,0]:[0,20,0]";
        //YScale 0.5;
    }

    States
    {
        Spawn:
            BOBB A 0;
            BOBB A 5 A_Look2;
            Loop;
            BOBB A 8;
            Loop;
            BOBB A 8;
            Loop;
            BOBB BBCCDDEE 4 A_Wander;
            BOBB E 0 A_Jump(4,1);
            Loop;
            BOBB E 0 A_StartSound("BOB33");
            Goto Spawn+3;
        See:
            BOBB BBCCDDEE 4 A_Chase;
            BOBB E 0 A_Jump(4,1);
            Loop;
            BOBB E 0 A_StartSound("BOB33");
            goto See;
        Pain:
            BOBB A 3;
            BOBB A 3 A_Pain;
            goto See;
        Death:
            BOBB F 5 A_Scream;
            BOBB F 1 A_Checkfloor("Death1");
            Wait;
        Death1:
            BOBB G 5 A_NoBlocking;
            BOBB G 1 A_Checkfloor("Death2");
            Wait;
        Death2:
            BOBB H 5;
            BOBB H 1 A_Checkfloor("Death3");
            Wait;
        Death3:
            BOBB I 1 A_StartSound("Splat");
            BOBB I -1 RemoveOnLava;
            Wait;
        XDeath:
            BOBB J 5 A_Scream;
            BOBB J 1 A_Checkfloor("XDeath1");
            Wait;
        XDeath1:
            BOBB K 5 A_NoBlocking;
            BOBB K 1 A_Checkfloor("XDeath2");
            Wait;
        XDeath2:
            BOBB L 5;
            BOBB L 1 A_Checkfloor("XDeath3");
            Wait;
        XDeath3:
            BOBB M 5;
            BOBB M 1 A_Checkfloor("XDeath4");
            Wait;
        XDeath4:
            BOBB N 1 A_XScream;
            BOBB N -1 RemoveOnLava;
            Wait;
        Death.Crush:
            BOBB J 5 A_StartSound("BURN");
            BOBB J 1 A_Checkfloor("Death.Crush1");
            Wait;
        Death.Crush1:
            BOBB K 5 A_NoBlocking;
            BOBB K 1 A_Checkfloor("Death.Crush2");
            Wait;
        Death.Crush2:
            BOBB L 5;
            BOBB L 1 A_Checkfloor("Death.Crush3");
            Wait;
        Death.Crush3:
            BOBB M 5;
            BOBB M 1 A_Checkfloor("Death.Crush4");
            Wait;
        Death.Crush4:
            BOBB N 1 A_XScream;
            BOBB N -1 RemoveOnLava;
            Wait;
        Burn:
            TNT1 A 0 A_SetTranslation("");
            BURN A 5 Bright A_StartSound("BURN");
            BURN A 1 Bright A_Checkfloor("Burn1");
            Wait;
        Burn1:
            BURN B 5 Bright A_NoBlocking;
            BURN B 1 Bright A_Checkfloor("Burn2");
            Wait;
        Burn2:
            BURN C 5 Bright;
            BURN C 1 Bright A_Checkfloor("Burn3");
            Wait;
        Burn3:
            BURN D 5 Bright;
            BURN D 1 Bright A_Checkfloor("Burn4");
            Wait;
        Burn4:
            BURN E -1 RemoveOnLava;
            Stop;
        Death.LavaFire:
            TNT1 A 0 A_SetTranslation("");
            BURN A 0 Bright A_NoBlocking;
            BURN A 5 Bright A_StartSound("BURN");
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

class Bob2 : Bob1
{
    Default
    {
        //$Title "Civilian Science"
        Translation "64:79=[149,76,46]:[31,19,19]", "112:127=[0,176,201]:[0,30,34]";
    }
  
}

class Bob3 : Bob1
{
    Default
    {
        //$Title "Civilian Security"
        Translation "64:79=[149,76,46]:[31,19,19]", "112:127=[246,37,0]:[36,5,0]";
    }
}

class Bob4 : Bob1
{
    Default
    {
        //$Title "Civilian Engineering"
        Translation "64:79=[149,76,46]:[31,19,19]", "112:127=[255,231,22]:[21,19,0]";
    }
}

class AssimilatedBob : MarathonActor
{
    Default
    {
        //$Title "Assimilated Civilian"
        MarathonActor.friendlyHud true;
        MONSTER;
        +FLOORCLIP;
        +DONTGIB;
        +NOSPLASHALERT;
        obituary "%o couldn't tell a bomb from a person.";
        health 1;
        radius 13;
        height 51;
        mass 100;
        speed 8;
        painchance 200;
        seesound "BOB34";
        attacksound "";
        painsound "";
        deathsound "SPNKR2";
        activesound "";
        scale .5;
        //YScale 0.5;
        BloodColor "Yellow";
        Translation "64:79=[149,76,46]:[31,19,19]", "112:127=[0,255,0]:[0,20,0]", "176:191=[255,231,22]:[43,38,0]", "32:47=[81,72,0]:[51,46,0]";
    }

    States
    {
        Spawn:
            BOBB A 10 A_Look;
            Loop;
        See:
            BOBB BBCCDDEE 4 A_Chase;
            BOBB E 0 A_Jump(4,1);
            Loop;
            BOBB E 0 A_StartSound("BOB34");
            goto See;
        Pain:
            BOBB A 3;
            BOBB A 3 A_Pain;
            goto See;
        Melee:
            BOBB A 3 A_FaceTarget;
            BOBB A 1 A_Die;
            Goto See;
        Death:
            BOBB J 0 A_SpawnItem("BoBBoom");
            BOBB J 5 Bright A_Scream;
            BOBB J 1 Bright A_Checkfloor("Death1");
            wait;
        Death1:
            BOBB K 5 Bright A_NoBlocking;
            BOBB K 1 Bright A_Checkfloor("Death2");
            wait;
        Death2:
            BOBB L 5 Bright;
            BOBB L 1 Bright A_Checkfloor("Death3");
            wait;
        Death3:
            BOBB M 5 Bright;
            BOBB M 1 Bright A_Checkfloor("Death4");
            wait;
        Death4:
            BOBB N 1 A_XScream;
            BOBB N -1 RemoveOnLava;
            wait;
        Burn:
            BURN A 5 Bright A_StartSound("BURN");
            BURN A 1 Bright A_Checkfloor("Burn1");
            wait;
        Burn1:
            BURN B 5 Bright A_NoBlocking;
            BURN B 1 Bright A_Checkfloor("Burn2");
            wait;
        Burn2:
            BURN C 5 Bright;
            BURN C 1 Bright A_Checkfloor("Burn3");
            wait;
        Burn3:
            BURN D 5 Bright;
            BURN D 1 Bright A_Checkfloor("Burn4");
            wait;
        Burn4:
            BURN E -1 RemoveOnLava;
            stop;
        Death.LavaFire:
            BURN A 0 Bright A_NoBlocking;
            BURN A 5 Bright A_StartSound("*burndeath");
            BURN A 1 Bright A_Checkfloor("Death.LavaFire1");
            wait;
        Death.LavaFire1:
            BURN B 5 Bright;
            BURN B 1 Bright A_Checkfloor("Death.LavaFire2");
            wait;
        Death.LavaFire2:
            BURN C 5 Bright;
            BURN C 1 Bright A_Checkfloor("Death.LavaFire3");
            wait;
        Death.LavaFire3:
            BURN D 5 Bright;
            BURN D 1 Bright A_Checkfloor("Death.LavaFire4");
            wait;
        Death.LavaFire4:
            BURN E -1 RemoveOnLava;
            stop;
    }
}

class BoBBoom : Actor
{
    Default
    {
        +EXTREMEDEATH;
        speed 1;
    }

    States
    {
        Spawn:
            TNT1 A 0;
            TNT1 A 0 A_Explode(128,128);
            Stop;
    }
}