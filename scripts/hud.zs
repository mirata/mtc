Class MarathonStatusBar : BaseStatusBar
{
	HUDFont mHUDFont;
	HUDFont mSmallFont;
	HUDFont mConsoleFont;
	HUDFont mIndexFont;
	HUDFont mAmountFont;
	InventoryBarState diparms;
	

	override void Init()
	{
		Super.Init();
		SetSize(0, 320, 200);

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

		if (state == HUD_StatusBar)
		{
			BeginHUD();
			DrawFullScreen1();
		}
		else if (state == HUD_Fullscreen)
		{
			BeginHUD();
			DrawFullScreen2();

			let scale = (0.6, 0.6);
			let radarCenter = (106, -94);
			let horizontalPosition = 110;
			let verticalPosition = -20;

			let radarOffset = (42, -28);
			let healthOffset = (202, -43);
			let oxygenOffset = (202, -15);
			let weaponOffset = (-10, -15);

			DrawImage("HUD", (-horizontalPosition, verticalPosition), DI_SCREEN_LEFT_BOTTOM  | DI_ITEM_LEFT_BOTTOM, 1, (-1, -1), scale);		
			DrawImage("RADAR", (-horizontalPosition + (radarOffset.x * scale.x), verticalPosition + (radarOffset.y * scale.y)), DI_SCREEN_LEFT_BOTTOM  | DI_ITEM_LEFT_BOTTOM, 1, (-1, -1), scale);			
            DrawImage("WPNHUD", (horizontalPosition, verticalPosition), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1, (-1, -1), scale);

			let weapon = GetWeaponTag();
			let weaponGraphic = "";
			if(weapon == "Magnum")
			{
				weaponGraphic = "PIST";
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
				Console.Printf("Is ma75");
				weaponGraphic = "MA75";
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

	Vector2 GetKeysBarWidthAndHeight () //(Credit to Blue Shadow)
	{
		Vector2 iconsize, barsize;

		for (let i = CPlayer.mo.Inv; i != null; i = i.Inv)
		{
			if (i is "Key" && i.Icon.IsValid())
			{
				iconsize = TexMan.GetScaledSize(i.Icon);
				barsize.x += iconsize.x + 2;
				barsize.y = Max(barsize.y, iconsize.y);
			}
		}

		return (barsize.x - 2, barsize.y);
	}

	override void DrawPowerups ()
	{
		Vector2 pos = (-20, POWERUPICONSIZE * 5 / 4); int flags;
		[pos, flags] = AdjustPosition((pos.x, pos.y - 20), DI_ITEM_CENTER, 8, 8);
		double maxpos = screen.GetWidth() / 2;
		for (let iitem = CPlayer.mo.Inv; iitem != NULL; iitem = iitem.Inv)
		{
			let item = Powerup(iitem);
			if (item != null)
			{
				let icon = item.GetPowerupIcon();
				if (icon.IsValid() && !item.IsBlinking())
				{
				
					// Get the amount of seconds left (tics / ticrate).
					int secondsLeft = int(Ceil(double(item.EffectTics) / GameTicRate));
					
					// Each icon gets a 32x32 block.
					DrawTexture(icon, pos, DI_ITEM_CENTER, 1.0, (POWERUPICONSIZE, POWERUPICONSIZE));
					DrawString(mSmallFont, FormatNumber(secondsLeft, 1, 3), (pos.x, pos.y + 3.8), DI_TEXT_ALIGN_CENTER, Font.CR_GREY);
					pos.x -= POWERUPICONSIZE;
					if (pos.x < -maxpos)
					{
						pos.x = -20;
						pos.y += POWERUPICONSIZE * 3 / 2;
					}
				}
			}
		}
	}

	void DrawFullScreen1 ()
	{	
		DrawSBarAirSupply();
		
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
		
		DrawString(mConsoleFont, "Keys", (-200, -32), DI_TEXT_ALIGN_CENTER);
		DrawSBarKeys();
		
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
	
	void DrawSBarAirSupply()
	{
			// Get the amount of seconds left (tics / ticrate).
			int secondsLeft = int(Ceil(double(GetAirTime()) / GameTicRate));

			// Draw the resulting value.
			DrawString(mSmallFont, FormatNumber(secondsLeft, 1, 3), (80, -12), DI_TEXT_ALIGN_CENTER, Font.CR_GREY);
	}
	
	void DrawSBarKeys() //(Credit to Blue Shadow)
	{
		Vector2 barsize = GetKeysBarWidthAndHeight();
		Vector2 keypos; int flags;
		[keypos, flags] = AdjustPosition((-196, -10), DI_ITEM_CENTER, barsize.x, barsize.y);
	
		for (let i = CPlayer.mo.Inv; i != null; i = i.Inv)
		{
			if (i is "Key" && i.Icon.IsValid())
			{
				DrawTexture(i.Icon, keypos, flags | DI_ITEM_CENTER);
				Vector2 size = TexMan.GetScaledSize(i.Icon);
				keypos.x += size.X + 2;
			}
		}
	}

	void DrawFullScreen2 ()
	{
		DrawString(mConsoleFont, "Health", (64, -32), DI_TEXT_ALIGN_CENTER);
		DrawString(mHUDFont, FormatNumber(CPlayer.health, 1, 4), (64, -22), DI_TEXT_ALIGN_CENTER);
		
		DrawString(mConsoleFont, "Armor", (64, -64), DI_TEXT_ALIGN_CENTER);
		let armor = CPlayer.mo.FindInventory("BasicArmor");
		if (armor != null && armor.Amount > 0)
		{
			DrawString(mHUDFont, FormatNumber(armor.Amount, 1, 4), (64, -54), DI_TEXT_ALIGN_CENTER);
		}
		else
		{
			DrawString(mHUDFont, FormatNumber(0, 1), (64, -54), DI_TEXT_ALIGN_CENTER);
		}
		
		DrawFullscreenAirSupply();
		
		if (!isInventoryBarVisible() && !Level.NoInventoryBar && CPlayer.mo.InvSel != null)
		{
			DrawInventoryIcon(CPlayer.mo.InvSel, (-110, -16), DI_DIMDEPLETED|DI_ITEM_CENTER);
			if (CPlayer.mo.InvSel.Amount > 1)
			{
				DrawString(mSmallFont, FormatNumber(CPlayer.mo.InvSel.Amount, 1, 2), (-110, -12), DI_TEXT_ALIGN_CENTER, Font.CR_GREY);
			}
		}
		
		DrawString(mConsoleFont, "Ammo", (-64, -32), DI_TEXT_ALIGN_CENTER);
		Inventory ammotype1;
		ammotype1 = GetCurrentAmmo();
		if (ammotype1 != null)
		{
			DrawString(mHUDFont, FormatNumber(ammotype1.Amount, 1, 4), (-64, -22), DI_TEXT_ALIGN_CENTER);
		}
		else
		{
			DrawString(mHUDFont, FormatNumber(0, 1), (-64, -22), DI_TEXT_ALIGN_CENTER);
		}
		
		DrawString(mConsoleFont, "Keys", (-64, -64), DI_TEXT_ALIGN_CENTER);
		DrawFullscreenKeys();
		
		if (isInventoryBarVisible())
		{
			DrawInventoryBar(diparms, (0, 0), 7, DI_SCREEN_CENTER_BOTTOM, HX_SHADOW);
		}
	}
	
	void DrawFullscreenAirSupply()
	{
		if (CPlayer.mo.waterlevel == 3)
		{
			// Get the amount of seconds left (tics / ticrate).
			int secondsLeft = int(Ceil(double(GetAirTime()) / GameTicRate));

			// Draw the resulting value.
			DrawString(mSmallFont, FormatNumber(secondsLeft, 1, 3), (110, -12), DI_TEXT_ALIGN_CENTER, Font.CR_GREY);
		}
	}
	
	void DrawFullscreenKeys() //(Credit to Blue Shadow)
	{
		Vector2 barsize = GetKeysBarWidthAndHeight();
		Vector2 keypos; int flags;
		[keypos, flags] = AdjustPosition((-60, -42), DI_ITEM_CENTER, barsize.x, barsize.y);
	
		for (let i = CPlayer.mo.Inv; i != null; i = i.Inv)
		{
			if (i is "Key" && i.Icon.IsValid())
			{
				DrawTexture(i.Icon, keypos, flags | DI_ITEM_CENTER);
				Vector2 size = TexMan.GetScaledSize(i.Icon);
				keypos.x += size.X + 2;
			}
		}
	}
}