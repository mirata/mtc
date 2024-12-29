class Bob1 : MarathonActor
{
    Default
    {
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
        //YScale 0.5;
    }

    States
    {
        Spawn:
            DUDE A 0;
            DUDE A 5 A_Look2;
            Loop;
            DUDE A 8;
            Loop;
            DUDE A 8;
            Loop;
            DUDE BBCCDDEE 4 A_Wander;
            DUDE E 0 A_Jump(4,1);
            Loop;
            DUDE E 0 A_StartSound("BOB33");
            Goto Spawn+3;
        See:
            DUDE BBCCDDEE 4 A_Chase;
            DUDE E 0 A_Jump(4,1);
            Loop;
            DUDE E 0 A_StartSound("BOB33");
            goto See;
        Pain:
            DUDE A 3;
            DUDE A 3 A_Pain;
            goto See;
        Death:
            DUDE F 5 A_Scream;
            DUDE F 1 A_Checkfloor("Death1");
            Wait;
        Death1:
            DUDE G 5 A_NoBlocking;
            DUDE G 1 A_Checkfloor("Death2");
            Wait;
        Death2:
            DUDE H 5;
            DUDE H 1 A_Checkfloor("Death3");
            Wait;
        Death3:
            DUDE I 1 A_StartSound("Splat");
            DUDE I -1 ACS_Execute(779,0,0,0,0);
            Wait;
        XDeath:
            DUDE J 5 A_Scream;
            DUDE J 1 A_Checkfloor("XDeath1");
            Wait;
        XDeath1:
            DUDE K 5 A_NoBlocking;
            DUDE K 1 A_Checkfloor("XDeath2");
            Wait;
        XDeath2:
            DUDE L 5;
            DUDE L 1 A_Checkfloor("XDeath3");
            Wait;
        XDeath3:
            DUDE M 5;
            DUDE M 1 A_Checkfloor("XDeath4");
            Wait;
        XDeath4:
            DUDE N 1 A_XScream;
            DUDE N -1 ACS_Execute(779,0,0,0,0);
            Wait;
        Death.Crush:
            DUDE J 5 A_StartSound("BURN");
            DUDE J 1 A_Checkfloor("Death.Crush1");
            Wait;
        Death.Crush1:
            DUDE K 5 A_NoBlocking;
            DUDE K 1 A_Checkfloor("Death.Crush2");
            Wait;
        Death.Crush2:
            DUDE L 5;
            DUDE L 1 A_Checkfloor("Death.Crush3");
            Wait;
        Death.Crush3:
            DUDE M 5;
            DUDE M 1 A_Checkfloor("Death.Crush4");
            Wait;
        Death.Crush4:
            DUDE N 1 A_XScream;
            DUDE N -1 ACS_Execute(779,0,0,0,0);
            Wait;
        Burn:
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
            BURN E -1 {
                let tex = TexMan.GetName(self.FloorPic);
				Console.Printf("%s", tex);
                if(tex == "1SET19" || tex == "2SET12" || tex == "4SET05")
                {
                    A_SetRenderStyle(1, STYLE_None);
                }
            }
            Stop;
        Death.LavaFire:
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
            BURN E -1 ACS_Execute(779,0,0,0,0);
            Stop;
    }
}

class Bob2 : Bob1
{
    Default
    {
        //$Title "Civilian Science"
        Translation "112:127=[0,176,201]:[0,0,0]";
    }
  
}

class Bob3 : Bob1
{
    Default
    {
        //$Title "Civilian Security"
        Translation "112:127=[246,37,0]:[0,0,0]";
    }
}

class Bob4 : Bob1
{
    Default
    {
        //$Title "Civilian Engineering"
        Translation "112:127=[255,231,22]:[0,0,0]";
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
        Translation "176:191=[255,231,22]:[20,18,2]";
    }

    States
    {
        Spawn:
            DUDE A 10 A_Look;
            Loop;
        See:
            DUDE BBCCDDEE 4 A_Chase;
            DUDE E 0 A_Jump(4,1);
            Loop;
            DUDE E 0 A_StartSound("BOB34");
            goto See;
        Pain:
            DUDE A 3;
            DUDE A 3 A_Pain;
            goto See;
        Melee:
            DUDE A 3 A_FaceTarget;
            DUDE A 1 A_Die;
            Goto See;
        Death:
            DUDE J 0 A_SpawnItem("BoBBoom");
            DUDE J 5 Bright A_Scream;
            DUDE J 1 Bright A_Checkfloor("Death1");
            wait;
        Death1:
            DUDE K 5 Bright A_NoBlocking;
            DUDE K 1 Bright A_Checkfloor("Death2");
            wait;
        Death2:
            DUDE L 5 Bright;
            DUDE L 1 Bright A_Checkfloor("Death3");
            wait;
        Death3:
            DUDE M 5 Bright;
            DUDE M 1 Bright A_Checkfloor("Death4");
            wait;
        Death4:
            DUDE N 1 A_XScream;
            DUDE N -1 ACS_Execute(779,0,0,0,0);
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
            BURN E -1 ACS_Execute(779,0,0,0,0);
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
            BURN E -1 ACS_Execute(779,0,0,0,0);
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