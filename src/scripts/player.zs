class MarathonPlayer : PlayerPawn
{
    Default
    {
        +DONTGIB;
        +NOSKIN;
        +SLIDESONWALLS;
        Speed 1;
        Health 100;
        Radius 11;
        Height 51;
        Mass 100;
        PainChance 0;
        Player.ForwardMove .5,.5;
        Player.SideMove .5,.5;
        Player.DisplayName "Cyborg";
        Player.StartItem "Magnum";
        Player.StartItem "Punch";
        Player.StartItem "MagnumClip", 8;
        Player.StartItem "MagnumClip2", 8;
        Player.StartItem "MagnumAmmo", 3;
        Player.StartItem "MagnumCheck", 1;
        Player.StartItem "OxygenTank", 1000;
        Player.WeaponSlot 1, "Punch";
        Player.WeaponSlot 2, "Magnum", "Magnums";
        Player.WeaponSlot 3, "FusionPistol";
        Player.WeaponSlot 4, "MA75AssaultRifle";
        Player.WeaponSlot 5, "X17SSMLauncher";
        Player.Weaponslot 6, "TOZTFlamethrower";
        Player.WeaponSlot 7, "AlienWeapon";
        Player.ColorRange 112, 127;
        Player.MaxHealth 450;
        Player.ViewHeight 35; //40-35
        Player.ViewBob .1;
        Player.AttackZOffset 12;
        damagefactor "suffocate" ,1.0;
        PainChance "suffocate", 0;
        scale 0.35;
        YScale 0.5;
    }
    States
    {
        Spawn:
            PLAY E -1;
            Loop;
        See:
            PLAY ABCD 4;
            Loop;
        Missile:
            PLAY E 1;
            Goto Spawn;
        Melee:
            PLAY F 2 bright;
            PLAY E 1;
            Goto Spawn;
        Melee.Punch:
            PLAY F 4;
            PLAY E 1;
            Goto Spawn;
        Death:
            PLAY G 0 A_NoBlocking;
            PLAY G 5 A_Playerscream;
            PLAY G 1 A_Checkfloor("Death1");
            Wait;
        Death1:
            PLAY H 5;
            PLAY H 1 A_Checkfloor("Death2");
            Wait;
        Death2:
            PLAY I 5;
            PLAY I 1 A_Checkfloor("Death3");
            Wait;
        Death3:
            PLAY J 1 A_StartSound("Splat");
            PLAY J -1 ACS_Execute(779,0,0,0,0);
            Stop;
        Death.Drowning:
            PLAY G 0 A_NoBlocking;
            PLAY G 5 A_StartSound("*suffocate");
            PLAY G 1 A_Checkfloor("Death.Drowning1");
            Wait;
        Death.Drowning1:
            PLAY H 5;
            PLAY H 1 A_Checkfloor("Death.Drowning2");
            Wait;
        Death.Drowning2:
            PLAY I 5;
            PLAY I 1 A_Checkfloor("Death.Drowning3");
            Wait;
        Death.Drowning3:
            PLAY J 1;
            PLAY J -1 ACS_Execute(779,0,0,0,0);
            Stop;
        Death.Crush:
            PLAY G 0 A_NoBlocking;
            PLAY G 5 A_StartSound("*burndeath");
            PLAY G 1 A_Checkfloor("Death.Crush1");
            Wait;
        Death.Crush1:
            PLAY K 5;
            PLAY K 1 A_Checkfloor("Death.Crush2");
            Wait;
        Death.Crush2:
            PLAY L 5;
            PLAY L 1 A_Checkfloor("Death.Crush3");
            Wait;
        Death.Crush3:
            PLAY M 5;
            PLAY M 1 A_Checkfloor("Death.Crush4");
            Wait;
        Death.Crush4:
            PLAY N 1 A_XScream;
            PLAY N -1 ACS_Execute(779,0,0,0,0);
            Stop;
        XDeath:
            PLAY G 5 A_Playerscream;
            PLAY G 1 A_Checkfloor("XDeath1");
            Wait;
        XDeath1:
            PLAY K 5;
            PLAY K 1 A_Checkfloor("XDeath2");
            Wait;
        XDeath2:
            PLAY L 5;
            PLAY L 1 A_Checkfloor("XDeath3");
            Wait;
        XDeath3:
            PLAY M 5;
            PLAY M 1 A_Checkfloor("XDeath4");
            Wait;
        XDeath4:
            PLAY N 1 A_XScream;
            PLAY N -1 ACS_Execute(779,0,0,0,0);
            Stop;
        Burn:
            PLAY O 0 bright A_NoBlocking;
            PLAY O 5 bright A_StartSound("*burndeath");
            PLAY O 1 bright A_Checkfloor("Burn1");
            Wait;
        Burn1:
            PLAY P 5 bright;
            PLAY P 1 bright A_Checkfloor("Burn2");
            Wait;
        Burn2:
            PLAY Q 5 bright;
            PLAY Q 1 bright A_Checkfloor("Burn3");
            Wait;
        Burn3:
            PLAY R 5 bright;
            PLAY R 1 bright A_Checkfloor("Burn4");
            Wait;
        Burn4:
            PLAY S -1 ACS_Execute(779,0,0,0,0);
            stop;
        Death.LavaFire:
            PLAY O 0 bright A_NoBlocking;
            PLAY O 5 bright A_StartSound("*burndeath");
            PLAY O 1 bright A_Checkfloor("Death.LavaFire1");
            Wait;
        Death.LavaFire1:
            PLAY P 5 bright;
            PLAY P 1 bright A_Checkfloor("Death.LavaFire2");
            Wait;
        Death.LavaFire2:
            PLAY Q 5 bright;
            PLAY Q 1 bright A_Checkfloor("Death.LavaFire3");
            Wait;
        Death.LavaFire3:
            PLAY R 5 bright;
            PLAY R 1 bright A_Checkfloor("Death.LavaFire4");
            Wait;
        Death.LavaFire4:
            PLAY S -1 ACS_Execute(779,0,0,0,0);
            stop;
    }

    // double lastSpeed;

    // override void Tick()
    // {
    //     super.Tick();

    //     // Track current speed
    //     double currentSpeed = vel.Length();
    //     double expectedSpeed = lastSpeed;
    //     if(MovementBlockingLine != null && currentSpeed < expectedSpeed) {
    //         Console.Printf("Expectd speed : %f, Actual speed: %f", expectedSpeed, currentSpeed);
    //         let newVel = vel.Unit() * (currentSpeed * 2);
    //         Vel.x = newVel.x;
    //         Vel.y = newVel.y;
    //         Vel.z = newVel.z; // Preserve vertical velocity  
    //     }
    //     // Detect wall contact
    //     // if (IsTouchingWall())
    //     // {
    //     //     // Re-normalize velocity to restore original magnitude
    //     //     if (currentSpeed < expectedSpeed)
    //     //     {
    //     //         vel = vel.Unit() * expectedSpeed;
    //     //     }
    //     // }

    //     lastSpeed = vel.Length();
    // }

    // bool IsTouchingWall()
    // {
    //     // Broadly detect wall contact using actor flags or sector touch
    //     return (flags & MF_TOUCHWALL) != 0;
    // }
}