Class MarathonStatusBar : BaseStatusBar
{
	HUDFont mHUDFont;
	HUDFont mSmallFont;
	HUDFont mConsoleFont;
	HUDFont mIndexFont;
	HUDFont mAmountFont;
	InventoryBarState diparms;

	bool vrDisabled;
	

	override void Init()
	{
		Super.Init();
		SetSize(0, 320, 200);

		vrDisabled = CVar.GetCVar("vr_disabled").GetBool();

		// Create the font used for the fullscreen HUD
		Font fnt = "INDEXFONT";
		mHUDFont = HUDFont.Create(fnt, fnt.GetCharWidth("0"), Mono_CellCenter, 1, 1);
		fnt = "INDEXFONT";
		mSmallFont = HUDFont.Create(fnt, fnt.GetCharWidth("0"), Mono_CellCenter, 1, 1);
		fnt = "INDEXFONT";
		mConsoleFont = HUDFont.Create(fnt, fnt.GetCharWidth("0"), Mono_CellCenter, 1, 1);
		fnt = "INDEXFONT";
		mIndexFont = HUDFont.Create(fnt, fnt.GetCharWidth("0"), Mono_CellCenter);
		mAmountFont = HUDFont.Create("INDEXFONT");
		
		diparms = InventoryBarState.Create();
	}

	override void Draw (int state, double TicFrac)
	{
		Super.Draw (state, TicFrac);

		//Console.PrintF("VR Disabled: %d", vrDisabled);

		if (state == HUD_StatusBar)
		{
			BeginHUD();
			DrawFullScreen1();
		}
		else if (state == HUD_Fullscreen)
		{
			BeginHUD();

			let scale = (0.6, 0.6);
			let radarCenter = (106, -94);
			let horizontalPosition = vrDisabled ? 0 : 110;
			let verticalPosition = -20;

			let radarOffset = (42, -28);
			let healthOffset = (202, -43);
			let oxygenOffset = (202, -15);
			let weaponOffset = (-20, -15);

			DrawImage("HUD", (-horizontalPosition, verticalPosition), DI_SCREEN_LEFT_BOTTOM  | DI_ITEM_LEFT_BOTTOM, 1, (-1, -1), scale);		
			DrawImage("RADAR", (-horizontalPosition + (radarOffset.x * scale.x), verticalPosition + (radarOffset.y * scale.y)), DI_SCREEN_LEFT_BOTTOM  | DI_ITEM_LEFT_BOTTOM, 1, (-1, -1), scale);			
            DrawImage("WPNHUD", (horizontalPosition, verticalPosition), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1, (-1, -1), scale);


				// DrawString(mHUDFont, "Test", (-20, -22), DI_SCREEN_RIGHT_BOTTOM | DI_TEXT_ALIGN_RIGHT);		
				// DrawString(mConsoleFont, "Keys", (-20, -32), DI_SCREEN_RIGHT_BOTTOM | DI_TEXT_ALIGN_RIGHT);
				// DrawString(mSmallFont, "sdsfadsf", (-110, -12), DI_TEXT_ALIGN_CENTER, Font.CR_GREY);
				
			Ammo am1, am2;
			int am1amt, am2amt;
			[am1, am2, am1amt, am2amt] = GetCurrentAmmo();

			let ammoOffset = (-200, -10);
			let ammo2Offset = (-200, -10);
			let weapon = GetWeaponTag();
			let weaponGraphic = "";
			if(weapon == "Magnum")
			{
				weaponGraphic = "PIST";
				
				ammoOffset = (-110, -21);
				for(int i = 0; i < 8; i++)
				{
					DrawImage((i + 1) > am1amt ? "PSTLAM2" : "PSTLAM", (horizontalPosition + ((ammoOffset.x - (i * 8)) * scale.x), verticalPosition + (ammoOffset.y * scale.y)), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1, (-1, -1), scale);
				}
			} 
			else if(weapon == "Magnums")
			{
				weaponGraphic = "PIST2";
			}
			else if(weapon == "FusionPistol")
			{
				weaponGraphic = "FUSION";
			}
			else if(weapon == "MA75AssaultRifle")
			{
				weaponGraphic = "MA75";
				
				ammoOffset = (-340, -83);
				ammo2Offset = (-332, -17);
				for(int i = 0; i < 4; i++)
				{
					for(int j = 0; j < 13; j++)
					{
						DrawImage((j + (i * 13) + 1) > am1amt ? "MA75AM2" : "MA75AM", (horizontalPosition + ((ammoOffset.x + (j * 6)) * scale.x), verticalPosition + ((ammoOffset.y + (i * 15)) * scale.y)), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1, (-1, -1), scale);
					}
				}
				
				for(int i = 0; i < 7; i++)
				{
					DrawImage((i + 1) > am2amt ? "GRNDAM2" : "GRNDAM", (horizontalPosition + ((ammo2Offset.x + (i * 10)) * scale.x), verticalPosition + (ammo2Offset.y * scale.y)), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1, (-1, -1), scale);
				}
		
			}
			else if(weapon == "X17SSMLauncher")
			{
				weaponGraphic = "SPNKR";
			}
			else if(weapon == "TOZTFlamethrower")
			{
				weaponGraphic = "TOZT";
			}
			else if(weapon == "AlienWeapon")
			{
				weaponGraphic = "ALNWPN";
			}
			if(weaponGraphic != "")
			{
				DrawImage(weaponGraphic, (horizontalPosition + (weaponOffset.x * scale.x), verticalPosition + (weaponOffset.y * scale.y)), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1, (-1, -1), scale);
			}

			int assaultAmmo, maxAssaultAmmo;
			[assaultAmmo, maxAssaultAmmo] = GetAmount('AssaultAmmo');

			int grenadeAmmo, maxGrenadeAmmo;
			[grenadeAmmo, maxGrenadeAmmo] = GetAmount('GrenadeAmmo');

			//Console.Printf("%d, %d, %d, %d", am1amt, am2amt, assaultAmmo, grenadeAmmo);


			/*for(int i = 0; i < 10; i++)
			{
				DrawImage("MA75AM", (horizontalPosition + ((ammoOffset.x + (i * 6)) * scale.x), verticalPosition + (ammoOffset.y * scale.y)), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1, (-1, -1), scale);
			}*/

			if(CPlayer.mo.health > 300)
			{
				double healthPercent = (CPlayer.mo.health - 300.0) / 150.0;
            	DrawImage("HEALTH2", (-horizontalPosition + (healthOffset.x * scale.x), verticalPosition + (healthOffset.y * scale.y)), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, 1, (-1, -1), (scale.x, scale.y));
            	DrawImage("HEALTH3", (-horizontalPosition + (healthOffset.x * scale.x), verticalPosition + (healthOffset.y * scale.y)), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, 1, (-1, -1), (scale.x * healthPercent, scale.y));
			}
			else if(CPlayer.mo.health > 150)
			{
				double healthPercent = (CPlayer.mo.health - 150.0) / 150.0;
            	DrawImage("HEALTH1", (-horizontalPosition + (healthOffset.x * scale.x), verticalPosition + (healthOffset.y * scale.y)), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, 1, (-1, -1), (scale.x, scale.y));
            	DrawImage("HEALTH2", (-horizontalPosition + (healthOffset.x * scale.x), verticalPosition + (healthOffset.y * scale.y)), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, 1, (-1, -1), (scale.x * healthPercent, scale.y));
			}
			else
			{
				double healthPercent = CPlayer.mo.health / 150.0;
            	DrawImage("HEALTH1", (-horizontalPosition + (healthOffset.x * scale.x), verticalPosition + (healthOffset.y * scale.y)), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, 1, (-1, -1), (scale.x * healthPercent, scale.y));
			}

            DrawImage("BAR", (-horizontalPosition + (healthOffset.x * scale.x), verticalPosition + (healthOffset.y * scale.y)), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, 1, (-1, -1), scale, STYLE_Add);

			let oxygen = GetAmount("OxygenTank");
			let oxygenPercent = double(oxygen) / 420;
            DrawImage("OXYGEN", (-horizontalPosition + (oxygenOffset.x * scale.x), verticalPosition + (oxygenOffset.y * scale.y)), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, 1, (-1, -1), (scale.x * oxygenPercent, scale.y));
            DrawImage("BAR", (-horizontalPosition + (oxygenOffset.x * scale.x), verticalPosition + (oxygenOffset.y * scale.y)), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, 1, (-1, -1), scale, STYLE_Add);

			if(CPLayer.mo.Vel.Length() >= 0)
			{
				let opacity = CPLayer.mo.Vel.Length();
				if(opacity > 1)
				{
					opacity = 1;
				}
				DrawImage("FRNDHUD", (-horizontalPosition + (radarCenter.x * scale.x), verticalPosition + (radarCenter.y * scale.y)), DI_SCREEN_LEFT_BOTTOM  | DI_ITEM_LEFT_BOTTOM, opacity, (-1, -1), scale);
			}

			let it = ThinkerIterator.Create("MarathonActor");
			Thinker thinker = null;
			while (thinker = it.next())
			{
				let a = MarathonActor(thinker);
				if(a == null || a.health <= 0)
				{
					continue;
				}

				double dist = CPlayer.mo.Distance2D(a);
				if(dist > 448)
				{
					continue;
				}

				let pos = CPlayer.mo.pos;

				//these functions support portals
				let relativePosition = CPlayer.mo.Vec2To(a);
				let angle = CPlayer.mo.AngleTo(a);

				let offset = a.RotateVector((0, dist), angle - CPlayer.mo.angle);
				offset = (offset.x / 7, offset.y / 7);


				DrawImage(a.friendlyHud ? "FRNDHUD" : "ALNHUD", (-horizontalPosition + ((radarCenter.x + offset.x) * scale.x), verticalPosition + ((radarCenter.y - offset.y) * scale.y)), DI_SCREEN_LEFT_BOTTOM  | DI_ITEM_LEFT_BOTTOM, a.hudOpacity, (-1, -1), scale);

				// Console.Printf("Distance to BOB: %d", dist);
			}
		}
	}

	Actor FindClosestTarget(string className)
	{
		Actor closest = null;
		double closestDist = 0x7FFFFFFF; // Start with a very large distance
		let it = ThinkerIterator.Create(className);
		Actor a = null;
		while (a = Actor(it.next()))
		{
			if(a.health <= 0)
			{
				continue;
			}
			double dist = CPlayer.mo.Distance3D(a);
			Console.Printf("Distance to BOB: %d", dist);
			if (dist < closestDist)
			{
				closestDist = dist;
				closest = a;
			}
		}
		return closest;
	}

	void DrawFullScreen1 ()
	{			
		DrawString(mConsoleFont, "Health", (128, -32), DI_TEXT_ALIGN_CENTER);
		DrawString(mHUDFont, FormatNumber(CPlayer.health, 1, 4), (128, -22), DI_TEXT_ALIGN_CENTER);
		
		DrawString(mConsoleFont, "Armor", (200, -32), DI_TEXT_ALIGN_CENTER);
		let armor = CPlayer.mo.FindInventory("BasicArmor");
		if (armor != null && armor.Amount > 0)
		{
			DrawString(mHUDFont, FormatNumber(armor.Amount, 1, 4), (200, -22), DI_TEXT_ALIGN_CENTER);
		}
		else
		{
			DrawString(mHUDFont, FormatNumber(0, 1), (200, -22), DI_TEXT_ALIGN_CENTER);
		}
		
		DrawString(mConsoleFont, "Ammo", (-128, -32), DI_TEXT_ALIGN_CENTER);
		Inventory ammotype1;
		ammotype1 = GetCurrentAmmo();
		if (ammotype1 != null)
		{
			DrawString(mHUDFont, FormatNumber(ammotype1.Amount, 1, 4), (-128, -22), DI_TEXT_ALIGN_CENTER);
		}
		else
		{
			DrawString(mHUDFont, FormatNumber(0, 1), (-128, -22), DI_TEXT_ALIGN_CENTER);
		}
		
		if (!isInventoryBarVisible() && !Level.NoInventoryBar && CPlayer.mo.InvSel != null)
		{
			DrawInventoryIcon(CPlayer.mo.InvSel, (-80, -16), DI_DIMDEPLETED|DI_ITEM_CENTER);
			if (CPlayer.mo.InvSel.Amount > 1)
			{
				DrawString(mSmallFont, FormatNumber(CPlayer.mo.InvSel.Amount, 1, 2), (-80, -12), DI_TEXT_ALIGN_CENTER, Font.CR_GREY);
			}
		}
		
		if (isInventoryBarVisible())
		{
			DrawInventoryBar(diparms, (0, 0), 7, DI_SCREEN_CENTER_BOTTOM, HX_SHADOW);
		}
	}
}