class MA75AssaultRifle : Weapon
{
    action void A_MA75_FireHitscan(bool resetSequence = false)
    {
        A_FireCustomMissile("TracerBullet", random(-3, 3), 0, 0, 0, 0, random(-1, 2));
        A_FireBullets(14, 14, -1, 7, "marathonpuff", 1, 0);
        if (resetSequence)
        {
            A_TakeInventory("AssaultRifleSequence", 8);
        }
        else
        {
            A_GiveInventory("AssaultRifleSequence", 1);
        }
    }

    action void A_MA75_FireGrenade()
    {
        A_Light2();
        A_FireCustomMissile("GunLight", 0, 0, 0, 0, 0);
        A_FireCustomMissile("marathongrenade");
        A_Light0();
        A_Recoil(3);
    }

    Default
    {
        Weapon.SelectionOrder 44;
        Weapon.AmmoGive 52;
        Weapon.AmmoUse 1;
        Weapon.AmmoUse2 1;
        Weapon.Ammotype "assaultClip";
        Weapon.Ammotype2 "grenadeClip";
        //Weapon.WeaponScaleY 1;
        Inventory.Pickupmessage "MA-75 Assault Rifle";
        Obituary "%k turned %o into swiss cheese.";
        attacksound "ASSAULT1";
        weapon.yadjust 13;
        //weapon.sisterweapon "MA75GrenadeLauncher";
        scale 0.5;
        Weapon.PreferredSkin "PlayerRifle";
        Decal "BulletChip";
        // +ammo_optional;
        // +Alt_Ammo_optional;
        +WEAPON.NOALERT;
        // +NOAUTOAIM;
    }
    States
    {
        Ready:
            ASSU A 1 A_WeaponReady;
            Loop;
        Ready2:
            ASSU A 1 A_WeaponReady;
            Loop;
        Deselect:
            ASSU A 1 A_Lower;
            goto deselect;
        Select:
            ASSU A 1 A_Raise;
            goto select;
        Fire:
            ASSU A 0 A_Jumpifnoammo("dry");
            ASSU A 0 A_JumpIfInventory("Vacuum",1,"Vacuum");
            ASSU A 0 NoiseAlert(0,0);
            ASSU A 0 A_Recoil(0.1);
            ASSU A 0 A_Jumpifinventory("AssaultRifleSequence",8,"Fire9");
            ASSU A 0 A_Jumpifinventory("AssaultRifleSequence",7,"Fire8");
            ASSU A 0 A_Jumpifinventory("AssaultRifleSequence",6,"Fire7");
            ASSU A 0 A_Jumpifinventory("AssaultRifleSequence",5,"Fire6");
            ASSU A 0 A_Jumpifinventory("AssaultRifleSequence",4,"Fire5");
            ASSU A 0 A_Jumpifinventory("AssaultRifleSequence",3,"Fire4");
            ASSU A 0 A_Jumpifinventory("AssaultRifleSequence",2,"Fire3");
            ASSU A 0 A_Jumpifinventory("AssaultRifleSequence",1,"Fire2");
            ASSU A 0 A_Light1;
			ASSU B 3 bright A_MA75_FireHitscan;
            ASSU A 0 A_Light0;
            ASSU A 0 A_Refire;
            ASSU A 0 A_Jumpifnoammo("dry");
            Goto Ready;
        Fire2:
            ASSU A 0 A_Jumpifnoammo("dry");
            ASSU A 0 A_Light1;
			ASSU C 3 bright A_MA75_FireHitscan;
            ASSU A 0 A_Light0;
            ASSU A 0 A_Refire;
            ASSU A 0 A_Jumpifnoammo("dry");
            Goto Ready;
        Fire3:
            ASSU A 0 A_Jumpifnoammo("dry");
            ASSU A 0 A_Light1;
			ASSU D 3 bright A_MA75_FireHitscan;
            ASSU A 0 A_Light0;
            ASSU A 0 A_Refire;
            ASSU A 0 A_Jumpifnoammo("dry");
            Goto Ready;
        Fire4:
            ASSU A 0 A_Jumpifnoammo("dry");
            ASSU A 0 A_Light1;
			ASSU J 3 bright A_MA75_FireHitscan;
            ASSU A 0 A_Light0;
            ASSU A 0 A_Refire;
            ASSU A 0 A_Jumpifnoammo("dry");
            Goto Ready;
        Fire5:
            ASSU A 0 A_Jumpifnoammo("dry");
            ASSU A 0 A_Light1;
			ASSU K 3 bright A_MA75_FireHitscan;
            ASSU A 0 A_Light0;
            ASSU A 0 A_Refire;
            ASSU A 0 A_Jumpifnoammo("dry");
            Goto Ready;
        Fire6:
            ASSU A 0 A_Jumpifnoammo("dry");
            ASSU A 0 A_Light1;
			ASSU L 3 bright A_MA75_FireHitscan;
            ASSU A 0 A_Light0;
            ASSU A 0 A_Refire;
            ASSU A 0 A_Jumpifnoammo("dry");
            Goto Ready;
        Fire7:
            ASSU A 0 A_Jumpifnoammo("dry");
            ASSU A 0 A_Light1;
			ASSU M 3 bright A_MA75_FireHitscan;
            ASSU A 0 A_Light0;
            ASSU A 0 A_Refire;
            ASSU A 0 A_Jumpifnoammo("dry");
            Goto Ready;
        Fire8:
            ASSU A 0 A_Jumpifnoammo("dry");
            ASSU A 0 A_Light1;
			ASSU N 3 bright A_MA75_FireHitscan;
            ASSU A 0 A_Light0;
            ASSU A 0 A_Refire;
            ASSU A 0 A_Jumpifnoammo("dry");
            Goto Ready;
        Fire9:
            ASSU A 0 A_Jumpifnoammo("dry");
            ASSU A 0 A_Light1;
			ASSU O 3 bright A_MA75_FireHitscan(true);
            ASSU A 0 A_Light0;
            ASSU A 0 A_Refire;
            ASSU A 0 A_Jumpifnoammo("dry");
            Goto Ready;
        Vacuum:
            ASSU A 24 A_StartSound("DRY", CHAN_WEAPON);
            goto Ready;
        Dry:
            ASSU A 0 A_JumpIfInventory("assaultammo",1,"Reload");
            ASSU A 24 A_StartSound("DRY", CHAN_WEAPON);
            goto Ready;
        Reload:
            ASSU E 0 A_takeinventory("assaultammo",1);
            ASSU E 0 A_giveinventory("assaultclip",52);
            ASSU E 16 A_StartSound("MAGNUM2", CHAN_WEAPON);
            ASSU F 16;
            ASSU E 16;
            ASSU A 1;
            Goto Ready;
        AltFire:
            ASSU A 0 A_Jumpifnoammo("dry2");
            ASSU A 0 A_JumpIfInventory("Vacuum",1,"Vacuum");
            ASSU A 0 NoiseAlert(0,0);
            ASSU A 0 A_GunFlash;
			ASSU A 0 A_Jump(170,"Fire22","Fire23");
			ASSU B 4 bright A_MA75_FireGrenade;
			Goto AltCooldown;
        Fire22:
            ASSU A 0 A_Jumpifnoammo("dry2");
			ASSU C 4 bright A_MA75_FireGrenade;
			Goto AltCooldown;
        Fire23:
            ASSU A 0 A_Jumpifnoammo("dry2");
			ASSU D 4 bright A_MA75_FireGrenade;
			Goto AltCooldown;
		AltCooldown:
            // 4 tics firing + 14 tics cooldown = 18 tics (~0.51 seconds).
            ASSU A 25;
			ASSU A 0 A_Jumpifnoammo("dry2");
			Goto Ready2;
        Dry2:
            ASSU A 0 A_TakeInventory("MA75AssaultRifle", 1);
            ASSU A 0 A_JumpIfInventory("grenadeammo",1,"Reload2");
            ASSU A 24 A_StartSound("DRY", CHAN_WEAPON);
            goto Ready2;
        Reload2:
            ASSU E 0 A_takeinventory("grenadeammo",1);
            ASSU E 0 A_giveinventory("grenadeclip",7);
            ASSU E 16 A_StartSound("MAGNUM2", CHAN_WEAPON);
            ASSU F 16;
            ASSU E 16;
            ASSU A 1;
            Goto Ready2;
        Spawn:
            ASSU G -1;
            loop;
    }
}
class MA75AssaultRiflePickup : CustomInventory replaces chaingun
{
    Default{
  Inventory.PickupMessage "MA-75 Assault Rifle";
  scale 0.5;
  //YScale 0.5;
    }
  States
  {
  Spawn:
    ASSU G -1;
    Loop;
  Pickup:
    TNT1 A 0 A_JumpIfInventory("MA75AssaultRifle", 1, "PickupAmmo");
    TNT1 A 0 A_GiveInventory("MA75AssaultRifle");
	//TNT1 A 0 A_GiveInventory("ma75grenadelauncher");
    TNT1 A 0 A_GiveInventory("grenadeclip", 7); // start with grenades loaded
PickupAmmo:
    TNT1 A 0 A_GiveInventory("AssaultAmmo", 1);
	TNT1 A 0 A_GiveInventory("GrenadeAmmo", 1);
    Stop;
  }
}

class assaultammo : Ammo replaces clipbox
{
    Default
    {
        Inventory.PickupMessage "MA-75 Clip";
        Inventory.Amount 1;
        Inventory.MaxAmount 15;
        Ammo.BackpackAmount 1;
        Ammo.BackpackMaxAmount 15;
        Inventory.Icon "ASSUH0";
        scale 0.5;
        //YScale 0.5;
        +NOCLIP;
        radius 20;
        height 20;
    }
  States
  {
    Spawn:
        ASSU H -1;
        Stop;
  }
}
class AssaultClip : Ammo
{
    Default
    {
        Inventory.PickupMessage "durandal does not tolerate cheaters....";
        Inventory.Amount 0;
        Inventory.MaxAmount 52;
        Ammo.BackpackAmount 0;
        Ammo.BackpackMaxAmount 52;
        Inventory.Icon "ASSUG0";
    }
}
class AssaultRifleSequence : Ammo
{
    Default
    {
        Inventory.PickupMessage "durandal does not tolerate cheaters....";
        Inventory.Amount 0;
        Inventory.MaxAmount 8;
        Ammo.BackpackAmount 0;
        Ammo.BackpackMaxAmount 8;
        Inventory.Icon "ASSUG0";
    }
}
class GrenadeAmmo : Ammo replaces RocketAmmo
{
    Default
    {
        Inventory.PickupMessage "MA-75 Grenades";
        Inventory.Amount 1;
        Inventory.MaxAmount 8;
        Ammo.BackpackAmount 1;
        Ammo.BackpackMaxAmount 8;
        Inventory.Icon "ASSUI0";
        scale 0.5;
        radius 20;
        height 20;
    }
  States
  {
    Spawn:
        ASSU I -1;
        Stop;
  }
}
class GrenadeClip : Ammo
{
    Default
    {
        Inventory.PickupMessage "durandal does not tolerate cheaters....";
        Inventory.Amount 0;
        Inventory.MaxAmount 7;
        Ammo.BackpackAmount 0;
        Ammo.BackpackMaxAmount 7;
        Inventory.Icon "ASSUG0";
    }
}
class MarathonGrenade : Actor replaces grenade
{
    Default
    {
        seesound "ASSAULT2";
        deathsound "ASSAULT3";
        Radius 4;
        Height 8;
        Speed 15;
        Projectile;
        -DEHEXPLOSION;
        -NOGRAVITY;
        ;
        gravity 1;
        -DOOMBOUNCE;
        +FORCEXYBILLBOARD;
        +EXTREMEDEATH;
        -ROCKETTRAIL;
        scale 0.75;
        //YScale 0.75;
        damage 15;
        Decal "Scorch";
    }
    states
    {
        spawn:
        GREN A 1 bright A_spawnitem("marathongrenadesmoke");
        loop;
        death:
        GREN A 0 A_Nogravity;
        GREN A 1 bright A_explode(64,64);
        GREN BCDEFG 4 bright;
        stop;
    }
}

class MarathonGrenadeSmoke : Actor
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
    spawn:
        TNT1 A 3;
        SMKE ABCD 1 bright;
        stop;
    }
}