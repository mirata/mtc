class Magnum : Weapon
{
    Default
    {
        Weapon.SelectionOrder 1900;
        Weapon.AmmoUse 1;
        Weapon.AmmoGive 0;
        Weapon.AmmoType "MagnumClip";
        Weapon.AmmoUse2 1;
        Weapon.AmmoType2 "MagnumAmmo";
        //Weapon.WeaponScaleY 1;
        Obituary "%k put a cap in %o's ass.";
        Inventory.Pickupmessage "durandal does not tolerate cheaters....";
        Attacksound "MAGNUM1";
        +WEAPON.NOALERT;
        -ACTIVATEIMPACT;
        -ACTIVATEPCROSS;
        weapon.yadjust 12;
        Weapon.PreferredSkin "PlayerPistol";
        Decal "BulletChip";
        -ACTIVATEIMPACT;
    }
  
    States
    {
        Ready:
            MAGN A 1 A_WeaponReady;
            Loop;
        Deselect:
            MAGN A 1 A_Lower;
            Loop;
        Select:
            MAGN A 1 A_Raise;
            Loop;
        Fire:
            MAGN A 0 A_JumpIfNoAmmo("Dry");
            MAGN B 0 bright A_FireBullets(0,0,1,8,"MarathonPuff",1);
            MAGN A 0 A_Light1;
            MAGN A 0 A_FireCustomMissile("GunLight",0,0,0,0,0);
            MAGN B 5 bright NoiseAlert(0,0);
            MAGN C 6 bright A_TakeInventory("MagnumClip2",1);
            MAGN D 5 A_Light0;
            MAGN E 6;
            MAGN A 0 A_JumpIfNoAmmo("Dry");
            Goto Ready;
            //MAGN A 0 ACS_Execute(780,0,0,0,0);
            //Goto Ready;
        Dry:
            MAGN A 0 A_JumpIfInventory("MagnumAmmo",1,"Reload");
            MAGN A 24 A_PlayWeaponSound("DRY");
            //MAGN A 0 ACS_Execute(780,0,0,0,0);
            goto ready;
        Reload:
            MAGN A 0 A_JumpIfInventory("MagnumClip",8,"Ready");
            //MAGN A 0 A_JumpIfNoAmmo("Dry");
            MAGN F 25;
            MAGN G 0 A_TakeInventory("MagnumAmmo",1);
            MAGN G 0 A_GiveInventory("MagnumClip",8);
            MAGN G 0 A_GiveInventory("MagnumClip2",8);
            MAGN G 25 A_PlayWeaponSound("MAGNUM2");
            goto ready;
        Spawn:
            TNT1 A 1;
            Stop;
    }
}

class Magnums : Weapon
{
    Default
    {
        Weapon.SelectionOrder 1600;
        Weapon.AmmoUse 1;
        Weapon.AmmoGive 0;
        Weapon.AmmoType "MagnumClip2";
        Weapon.AmmoUse2 2;
        Weapon.AmmoType2 "MagnumAmmo";
        //Weapon.WeaponScaleY 1;
        Obituary "%k put 2 caps in %o's ass.";
        Inventory.Pickupmessage "durandal does not tolerate cheaters....";
        Attacksound "MAGNUM1";
        +WEAPON.NOALERT;
        weapon.yadjust 12;
        Weapon.PreferredSkin "PlayerWoo";
        Decal "BulletChip";
    }

    States
    {
        Ready:
            MAG2 A 1 A_WeaponReady;
            Loop;
        Deselect:
            MAG2 A 1 A_Lower;
            Loop;
        Select:
            MAG2 A 1 A_Raise;
            Loop;
        Fire:
            MAG2 A 0 A_JumpIfNoAmmo("Dry");
            MAG2 I 0 A_JumpIfInventory("MagnumClip",1,1);
            goto Fire+9;
            MAG2 B 0 bright A_FireBullets(0,0,1,8,"MarathonPuff",1);
            MAG2 B 0 A_Light1;
            MAG2 B 0 A_FireCustomMissile("GunLight",0,0,0,0,0);
            MAG2 B 2 bright NoiseAlert(0,0);
            MAG2 C 3 bright A_TakeInventory("MagnumClip",1);
            MAG2 D 2 A_Light0;
            MAG2 E 3;
            MAG2 A 0 A_JumpIfInventory("MagnumClip3",1,1);
            goto fire+18;
            MAG2 F 0 bright A_FireBullets(0,0,1,8,"MarathonPuff",1);
            MAG2 F 0 A_Light1;
            MAG2 F 0 A_FireCustomMissile("GunLight",0,0,0,0,0);
            MAG2 F 2 bright NoiseAlert(0,0);
            MAG2 G 3 bright A_TakeInventory("MagnumClip3",1);
            MAG2 H 2 A_Light0;
            MAG2 I 3;
            MAG2 A 0 A_JumpIfInventory("MagnumClip",1,"ready");
            MAG2 A 12 A_PlayWeaponSound("DRY");
            MAG2 A 0 A_Refire;
            Goto Ready;
            //MAG2 A 0 ACS_Execute(780,0,0,0,0);
            //Goto Ready;
        Dry:
            MAG2 A 12 A_PlayWeaponSound("DRY");
            MAG2 A 12 A_PlayWeaponSound("DRY");
            //MAG2 A 0 ACS_Execute(780,0,0,0,0);
            goto ready;
        AltFire:
            MAG2 A 0 A_JumpIfInventory("MagnumClip2",16,"Ready");
            MAG2 A 0 A_JumpIfNoAmmo("Ready");
            MAG2 A 0 A_JumpIfInventory("MagnumClip",8,6);
            MAGN F 25;
            MAGN G 0 A_TakeInventory("MagnumAmmo",1);
            MAG2 G 0 A_GiveInventory("MagnumClip",8);
            MAGN G 0 A_GiveInventory("MagnumClip2",8);
            MAGN G 25 A_PlayWeaponSound("MAGNUM2");
            MAG2 J 25;
            MAGN G 0 A_TakeInventory("MagnumAmmo",1);
            MAG2 G 0 A_GiveInventory("MagnumClip3",8);
            MAGN G 0 A_GiveInventory("MagnumClip2",8);
            MAG2 K 25 A_PlayWeaponSound("MAGNUM2");
            MAG2 G 0;
            goto ready;
        Spawn:
            TNT1 A 1;
            Stop;
    }
}