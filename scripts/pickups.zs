// ACTOR onexhealth : Health
// {
//   +COUNTITEM
//   +INVENTORY.AUTOACTIVATE
//   +INVENTORY.ALWAYSPICKUP
//   Inventory.Amount 150
//   Inventory.MaxAmount 150
//   Inventory.PickupMessage " "
//   Inventory.PickupSound "NONE"
//   States
//   {
//   Spawn:
//     TNT1 A -1
//     Loop
//   }
// }
// ACTOR twoxhealth : health
// {
//   +COUNTITEM
//   +INVENTORY.AUTOACTIVATE
//   +INVENTORY.ALWAYSPICKUP
//   Inventory.Amount 1
//   Inventory.MaxAmount 300
//   Inventory.PickupMessage " "
//   Inventory.PickupSound "NONE"
//   States
//   {
//   Spawn:
//     TNT1 A -1
//     Loop
//   }
// }
// ACTOR threexhealth : health
// {
//   +COUNTITEM
//   +INVENTORY.AUTOACTIVATE
//   +INVENTORY.ALWAYSPICKUP
//   Inventory.Amount 1
//   Inventory.MaxAmount 450
//   Inventory.PickupMessage " "
//   Inventory.PickupSound "NONE"
//   States
//   {
//   Spawn:
//     TNT1 A -1
//     Loop
//   }
// }
// ACTOR OxyPowerup : PowerupGiver
// {
//   Height 46
//   +INVENTORY.AUTOACTIVATE
//   +INVENTORY.ALWAYSPICKUP
//   Inventory.MaxAmount 0
//   Inventory.PickupMessage " "
//   Powerup.Type "IronFeet"
//   Powerup.Color "white", 0.0
//   Powerup.Duration -420
//   Inventory.pickupSound "NONE"
//   States
//   {
//   Spawn:
//     TNT1 A -1 Bright
//     Stop
//   }
// }

// class MarathonTeleportOut : TeleportFog
// {
//     Default{
//     }
//     States
//     {
//       Spawn:
//         TFOG DCBA 10 bright;
//         Stop;
//     }
// }
// class MarathonTeleportIn : TeleportFog
// {
//     Default{
//     }
//     States
//     {
//       Spawn:
//         TFOG ABCD 10 bright;
//         Stop;
//     }
// }

class MarathonTeleportOut : Actor
{
    Default{
    }
    States
    {
      Spawn:
        Stop;
    }
}

class MarathonTeleportIn : Actor
{
    Default{
    }
    States
    {
      Spawn:
        Stop;
    }
}
class MarathonRemoveTeleport : Actor
{
    Default{
    }
    States
    {
      Spawn:
        Stop;
    }
}
// ACTOR itemfog2 : itemfog replaces itemfog
// {
//   States
//   {
//     Spawn:
//       IFOG ABCD 3 bright
//       stop
//   }
// }

// ACTOR HyperVision : PowerupGiver replaces infrared
// {
//   +COUNTITEM
//   +INVENTORY.AUTOACTIVATE
//   +INVENTORY.ALWAYSPICKUP
//   Inventory.MaxAmount 0
//   Powerup.Duration 4200
//   Powerup.Color "00 00 55", 0.375
//   Powerup.Type "LightAmp"
//   Inventory.PickupMessage "HYPERVISION"
//   scale 0.5
//   //YScale 0.5
//   States
//   {
//     Spawn:
//     HYPO A -1 Bright
//     Loop
//   }
// }

class OxygenTank : Inventory
{
  Default {
    Inventory.PickupMessage "Durandal does not tolerate cheaters....";
    Inventory.Amount 0;
    Inventory.MaxAmount 1000;
    Inventory.Icon "TNT1A0"; 
    -INVENTORY.INVBAR;
  }
  States
  {
    Spawn:
      TNT1 A 1;
      Stop;
  }
}

class DefenseChip : Inventory
{
  Default
  {
    //$Title "Defense Chip"
    //$Category "Marathon Inventory"
    radius 20;
    height 20;
    Inventory.MaxAmount 3;
    Inventory.Amount 1;
    Inventory.PickupMessage "DEFENSE CENTER REPAIR CHIP";
    Inventory.Icon "ARTICHIP";
    scale 0.5;
  }
  States
  {
    Spawn:
      CHIP A -1;
      Stop;
  }
}
// actor PowerMarathonInvulnerable : PowerProtection
// {
// 	damagefactor "normal", 0.0
// 	damagefactor "crush", 1.0
// 	damagefactor "lavafire", 0.0
// 	damagefactor "fire", 0.0
// 	damagefactor "slime", 0.0
// 	damagefactor "Drowning", 1.0
// 	damagefactor "fusion", 1.0
// 	damagefactor "Railgun", 0.25
// }

// ACTOR Invulnerability : PowerupGiver replaces invulnerabilitysphere
// {
//   +COUNTITEM
//   +INVENTORY.AUTOACTIVATE
//   +INVENTORY.ALWAYSPICKUP
//   Inventory.MaxAmount 0
//   Powerup.Duration 2100
//   Powerup.Color "FF FF FF", 0.25
//   Powerup.Type "MarathonInvulnerable"
//   Inventory.PickupMessage "INVULNERABILITY"
//   scale 0.5
//   //YScale 0.5
//   States
//   {
//     Spawn:
//     INVU A -1 Bright
//     Loop
//   }
// }