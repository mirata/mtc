class AlienPickup : CustomInventory replaces BFG9000
{
    Default
    {
        Inventory.PickupMessage "65y';;l=-543.<<UNKNOWN WEAPON CLASS>>sy$^e> e))o) 0XFDED";
        scale 0.5;
        //YScale 0.5;
        inventory.pickupsound "misc/w_pkup";
    }
    states
    {
        spawn:
            ALEN E -1;
            loop;
        Pickup:
            TNT1 A 0 A_JumpIfInventory("AlienWeapon",1,2);
            TNT1 A 0 A_GiveInventory("AlienWeapon");
        Stop;
            TNT1 A 0;
            Fail;
    }
}
class AlienWeapon : Weapon
{
    Default
    {
        Weapon.SelectionOrder 400;
        Weapon.AmmoUse 1;
        Weapon.AmmoGive 75;
        Weapon.AmmoType "AlienClip";
        //Weapon.WeaponScaleY 1;
        +WEAPON.NOAUTOFIRE;
        scale 0.5;
        //YScale 0.5;
        attacksound "aliengun";
        weapon.yadjust 12;
        Obituary "%k owned %o pfhor style.";
        Weapon.PreferredSkin "PlayerPfhor";
        Decal "RailScorchLower";
    }
    States
    {
        Ready:
            ALEN A 0 A_JumpIfInventory("AlienClip", 1, "ReadyLoop");
            Goto Expire;
        ReadyLoop:
            ALEN A 1 A_WeaponReady;
            Loop;
        Select:
            ALEN A 1 A_Raise;
            Loop;
        Deselect:
            ALEN A 1 A_Lower;
            Loop;
        Expire:
            ALEN C 3 bright
            {
                Console.Printf("AlienWeapon Expire");
                A_TakeInventory("AlienWeapon", 1);
                A_TakeInventory("AlienWeaponSequence", 999);
            }
            Stop;
        Fire:
            ALEN A 0 A_JumpIfInventory("AlienClip", 1, "FireDo");
            Goto Expire;
        FireDo:
            ALEN A 0 A_Recoil(0.1);
            ALEN A 0 A_Jumpifinventory("alienweaponsequence",2,"Fire3");
            ALEN A 0 A_Jumpifinventory("alienweaponsequence",1,"Fire2");
            ALEN A 0 A_Light2;
            ALEN A 0 A_FireCustomMissile("GunLight",0,0,0,0,0);
            ALEN B 3 bright A_FireBullets(7.5,0,3,5,"AlienPuff", FBF_USEAMMO);
            ALEN A 0 A_Light0;
            ALEN A 0 A_GiveInventory("AlienWeaponSequence",1);
            ALEN A 0 A_JumpIfNoAmmo("Expire");
            ALEN A 1 A_Refire;
            ALEN A 0 A_JumpIfInventory("AlienClip", 1, "Ready");
            Goto Expire;
            Fire2:
            ALEN A 0 A_JumpIfInventory("AlienClip", 1, "Fire2Do");
            Goto Expire;
        Fire2Do:
            ALEN A 0 A_Light2;
            ALEN A 0 A_FireCustomMissile("GunLight",0,0,0,0,0);
            ALEN C 3 bright A_FireBullets(7.5,0,3,5,"AlienPuff", FBF_USEAMMO);
            ALEN A 0 A_Light0;
            ALEN A 0 A_GiveInventory("AlienWeaponSequence",1);
            ALEN A 0 A_JumpIfNoAmmo("Expire");
            ALEN A 1 A_Refire;
            ALEN A 0 A_JumpIfInventory("AlienClip", 1, "Ready");
            Goto Expire;
            Fire3:
            ALEN A 0 A_JumpIfInventory("AlienClip", 1, "Fire3Do");
            Goto Expire;
        Fire3Do:
            ALEN A 0 A_Light2;
            ALEN A 0 A_FireCustomMissile("GunLight",0,0,0,0,0);
            ALEN D 3 bright A_FireBullets(7.5,0,3,5,"AlienPuff", FBF_USEAMMO);
            ALEN A 0 A_Light0;
            ALEN A 0 A_TakeInventory("AlienWeaponSequence",2);
            ALEN A 0 A_JumpIfNoAmmo("Expire");
            ALEN A 1 A_Refire;
            ALEN A 0 A_JumpIfInventory("AlienClip", 1, "Ready");
            Goto Expire;
        Spawn:
            ALEN E -1;
            Stop;
    }
}
class alienweaponsequence : Ammo
{
    Default
    {
        Inventory.PickupMessage "durandal does not tolerate cheaters....";
        Inventory.Amount 0;
        Inventory.MaxAmount 2;
        Ammo.BackpackAmount 0;
        Ammo.BackpackMaxAmount 2;
        Inventory.Icon "ASSUG0";
    }
}
class alienclip : Ammo
{
    Default
    {
        Inventory.PickupMessage "durandal does not tolerate cheaters....";
        Inventory.Amount 0;
        Inventory.MaxAmount 75;
        Ammo.BackpackAmount 0;
        Ammo.BackpackMaxAmount 75;
        Inventory.Icon "ALENAMMO";
    }
}
class AlienPuff : MarathonPuff
{
    Default
    {
        scale 0.375;
        //YScale 0.375;
        +PUFFONACTORS;
        +FORCEXYBILLBOARD;
        +BLOODLESSIMPACT;
    }
    States
    {
        Spawn:
            APUF ABCDE 2 bright;
            stop;
        Crash:
            APUF ABCDE 2 bright;
            stop;
    }
}