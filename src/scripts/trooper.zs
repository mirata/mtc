class Trooper1 : MarathonActor
{
    Default
    {
        //marathon scale factor 6
        //$Title "Trooper"
        //$Angled
        //$Category "Marathon Monsters"
        MarathonActor.hurtByLava true;
        MONSTER;
        +NOSPLASHALERT;
        +DONTGIB;
        +FLOORCLIP;
        obituary "%o was shot by a trooper.";
        hitobituary "%o was shot by a trooper.";
        health 110;
        radius 10;
        height 56;
        mass 100;
        speed 5;
        painchance 0;
        Translation "112:127=[4,198,101]:[0,32,27]", "199:207=[9,191,206]:[0,98,130]", "240:247=[1,69,88]:[0,0,0]";
        seesound "PFHOR";
        painsound "";
        attacksound "ASSAULT1";
        deathsound "PFHORDIE";
        activesound "PFHOR";
        bloodcolor "ff ff 33";
        Decal "BulletChip";
        scale 0.375;
        //YScale 0.4;
    }

    action void A_TrooperFireBullet()
    {
        // Make the *final* hitscan damage be exactly 11..19.
        // A_CustomBulletAttack normally multiplies by random(1,3) unless CBAF_NORANDOM is set.
        A_CustomBulletAttack(6, 6, 1, random(5, 8), "marathonpuff", 0, CBAF_NORANDOM);
    }


// 	void A_TroopAttack()
// 	{
// 		let targ = target;
// 		if (targ)
// 		{
// 			if (CheckMeleeRange())
// 			{
// 				int damage = random[pr_troopattack](1, 8) * 3;
// 				A_StartSound ("imp/melee", CHAN_WEAPON);
// 				int newdam = targ.DamageMobj (self, self, damage, "Melee");
// 				targ.TraceBleed (newdam > 0 ? newdam : damage, self);
// 			}
// 			else
// 			{
// 				// launch a missile
// 				SpawnMissile (targ, "DoomImpBall");
// 			}
// 		}
// 	}

    States
    {
        Spawn:
            TROP E 10 A_Look;
            loop;
        See:
            TROP A 0 TargetPlayerAllies();
            TROP ABCD 3 A_Chase;
            loop;
        FaceTarget:
            TROP E 3 A_FaceTarget;
            TNT1 A 0
            {
                if(!cooldown) {
                    SetStateLabel("See");
                }
            }
            Loop;
        Missile:
            TNT1 A 0
            {
                if(cooldown) {
                    SetStateLabel("See");
                }
            }
            TROP E 1 A_Jump(256,"Missile2");
            TROP E 2 A_FaceTarget;
            TROP F 2 bright A_TrooperFireBullet;
            TROP E 2;
            TROP F 2 bright A_TrooperFireBullet;
            TROP E 2;
            TROP F 2 bright A_TrooperFireBullet;
            TROP E 2;
			TNT1 A 0
            {
                cooldown = true; 
            }
            goto See;
        Missile2:
            TNT1 A 0
            {
                if(cooldown) {
                    SetStateLabel("See");
                }
            }
            TROP E 3 A_FaceTarget;
            TROP F 3 bright A_CustomMissile("TrooperGrenade",22,-16,random(-10,10),8,0);
            TROP E 3;
			TNT1 A 0
            {
                cooldown = true;
            }
            goto See;
        Death:
            TROP G 0 A_FaceTarget;
            TROP G 8 A_Scream;
            TROP G 1 A_CheckFloor("Death2");
            wait;
        Death2:
            TROP H 8 A_NoBlocking;
            TROP H 1 A_CheckFloor("Death3");
            wait;
        Death3:
            TROP I 8;
            TROP I 1 A_CheckFloor("Death4");
            wait;
        Death4:
            TROP J 1 A_StartSound("Splat");
            TROP J -1 RemoveOnLava;
            stop;
        Death.Crush:
            TROP G 0 A_FaceTarget;
            TROP G 8 A_StartSound("PFHORBURN");
            TROP G 1 A_CheckFloor("Death.Crush2");
            wait;
        Death.Crush2:
            TROP H 8 A_NoBlocking;
            TROP H 1 A_CheckFloor("Death.Crush3");
            wait;
        Death.Crush3:
            TROP I 8;
            TROP I 1 A_CheckFloor("Death.Crush4");
            wait;
        Death.Crush4:
            TROP J 1 A_StartSound("Splat");
            TROP J -1 RemoveOnLava;
            stop;
        Burn:
            TNT1 A 0 A_SetTranslation("");
            BURN A 5 bright A_StartSound("PFHORBURN");
            BURN A 1 bright A_CheckFloor("Burn2");
            wait;
        Burn2:
            BURN B 5 bright A_NoBlocking;
            BURN B 1 bright A_CheckFloor("Burn3");
            wait;
        Burn3:
            BURN C 5 bright;
            BURN C 1 bright A_CheckFloor("Burn4");
            wait;
        Burn4:
            BURN D 5 bright;
            BURN D 1 bright A_CheckFloor("Burn5");
            wait;
        Burn5:
            BURN E -1 RemoveOnLava;
            stop;
        Death.LavaFire:
            TNT1 A 0 A_SetTranslation("");
            BURN A 0 bright A_NoBlocking;
            BURN A 5 bright A_StartSound("PFHORBURN");
            BURN A 1 bright A_Checkfloor("Death.LavaFire1");
            wait;
        Death.LavaFire1:
            BURN B 5 bright;
            BURN B 1 bright A_Checkfloor("Death.LavaFire2");
            wait;
        Death.LavaFire2:
            BURN C 5 bright;
            BURN C 1 bright A_Checkfloor("Death.LavaFire3");
            wait;
        Death.LavaFire3:
            BURN D 5 bright;
            BURN D 1 bright A_Checkfloor("Death.LavaFire4");
            wait;
        Death.LavaFire4:
            BURN E -1 RemoveOnLava;
            stop;
    }
}
class Trooper2 : Trooper1
{
  Default
  {
    //$Title "Trooper Major"
    health 200;
    speed 6;
    Translation "112:127=[161,0,100]:[0,0,0]";
  }

  States
  {
    Missile:
        TNT1 A 0
        {
            if(cooldown) {
                SetStateLabel("FaceTarget");
            }
        }
      TROP E 1 A_Jump(48,"Missile2");
      TROP E 2 A_FaceTarget;
            TROP F 2 bright A_TrooperFireBullet;
      TROP E 2;
            TROP F 2 bright A_TrooperFireBullet;
      TROP E 2;
            TROP F 2 bright A_TrooperFireBullet;
      TROP E 2;
            TROP F 2 bright A_TrooperFireBullet;
      TROP E 2;
            TROP F 2 bright A_TrooperFireBullet;
      TROP E 2;
            TROP F 2 bright A_TrooperFireBullet;
      TROP E 2;
            TROP F 2 bright A_TrooperFireBullet;
      TROP E 2;
            TROP F 2 bright A_TrooperFireBullet;
      TROP E 2;
        TNT1 A 0
        {
            cooldown = true;
        }
      goto See;
    Missile2:
        TNT1 A 0
        {
            if(cooldown) {
                SetStateLabel("FaceTarget");
            }
        }
      TROP E 3 A_FaceTarget;
        TROP F 3 bright A_CustomMissile("TrooperGrenade",22,-16,random(-5,5),8,0);
      TROP E 3;
        TROP F 3 bright A_CustomMissile("TrooperGrenade",22,-16,random(-5,5),8,0);
      TROP E 3;
        TNT1 A 0
        {
            cooldown = true;
        }
      goto See;
  }
}

class TrooperGrenade : Actor
{
  Default
  {
    Projectile;
    -DEHEXPLOSION;
    -NOGRAVITY;
    -DOOMBOUNCE;
    +FORCEXYBILLBOARD;
    +EXTREMEDEATH;
        Radius 4;
        Height 8;
    Gravity 1;
    Speed 10;
    DamageFunction GetDamage();
    seesound "ASSAULT1";
    deathsound "ASSAULT3";
    Decal "Scorch";
    damagetype "None";
    scale 0.75;
    //YScale 0.75;
    damage 4;
  }

    bool isClose;
    double closeDistance;
    bool played;
    
    int GetDamage()
	{
		return random(20, 60);
	}

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
            S_StartSound("GRNFBY", 0, 0, 1, ATTN_NORM, 0.0, 0.0);
            played = true;
            }
        }
    }

  States
  {
    spawn:
      TGRN A 1 bright;
      loop;
    death:
      GREN A 0 A_Nogravity;
      GREN A 1 bright A_explode(32,32,1);
      GREN BCDEFG 4 bright;
      stop;
  }
}