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
			DrawFullScreen1 ();
		}
		else if (state == HUD_Fullscreen)
		{
			BeginHUD();
			DrawFullScreen2();

			let scale = (0.5, 0.5);
			let radarCenter = (3, -47);

			DrawImage("HUD", (-50, 0), DI_SCREEN_LEFT_BOTTOM  | DI_ITEM_LEFT_BOTTOM, 1, (-1, -1), scale);
			DrawImage("RADAR", (radarCenter.x - 32.5, radarCenter.y + 33), DI_SCREEN_LEFT_BOTTOM  | DI_ITEM_LEFT_BOTTOM, 1, (-1, -1), scale);
			
            DrawImage("AR75", (50, 0), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, 1, (-1, -1), scale);

			let healthLeftover = CPlayer.mo.health % 150;
			double healthPercent = CPlayer.mo.health / 150.0;

			let pos = (10, -20);
            // DrawImage("BAR", pos, DI_SCREEN_CENTER_BOTTOM | DI_ITEM_LEFT_TOP, 1, (-1, -1), scale);
            DrawImage("HEALTH1", (106, -26.5), DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM, 1, (-1, -1), (0.5 * healthPercent, 0.5));

			// let tex = TexMan.CheckForTexture("HEALTH1");
			// let size = TexMan.GetScaledSize(tex);
			// SetClipRect(pos.x, pos.y, size.x * 0.5, size.y * 0.5, DI_SCREEN_CENTER_BOTTOM);
			// DrawTexture(tex, pos, DI_SCREEN_CENTER_BOTTOM | DI_ITEM_LEFT_TOP, 1, (-1, -1), scale);
			// ClearClipRect();


            // DrawImage("BAR", (10, -10), DI_SCREEN_CENTER_BOTTOM);
            // DrawBar("HEALTH1", "BAR", CPlayer.health, 150, (10, -10), 0, SHADER_HORZ, DI_SCREEN_CENTER_BOTTOM);
			
            // DrawBar("HPBAR", "BLANKBAR", CPlayer.health * 3, 450, (10, -10), 0, SHADER_VERT | SHADER_REVERSE, DI_SCREEN_LEFT_BOTTOM);
			
			if(CPLayer.mo.Vel.Length() >= 0)
			{
				let opacity = CPLayer.mo.Vel.Length();
				if(opacity > 1)
				{
					opacity = 1;
				}
				DrawImage("FRNDHUD", (radarCenter.x, radarCenter.y), DI_SCREEN_LEFT_BOTTOM  | DI_ITEM_LEFT_BOTTOM, opacity, (-1, -1), (0.5, 0.5));
			}

			let it = ThinkerIterator.Create("Actor");
			Actor a = null;
			while (a = Actor(it.next()))
			{
				if(a.health <= 0 || a == CPlayer.mo)
				{
					continue;
				}

				bool show = false;
				bool friendly = false;
				let className = a.GetClassName();

				if(className == "Fighter1" || className == "Fighter2" || className == "Fighter3" || className == "Fighter4")
				{
					show = true;
				}
				if(className == "Bob1" || className == "Bob2" || className == "Bob3" || className == "Bob4")
				{
					show = true;
					friendly = true;
				}
				if(!show)
				{
					continue;
				}

				double dist = CPlayer.mo.Distance3D(a);
				if(dist > 448)
				{
					continue;
				}
				
				let pos = CPlayer.mo.pos;

				Vector2 relativePosition = ((a.pos.x - pos.x) / 14, (a.pos.y - pos.y) / 14);
				let offset = CPlayer.mo.RotateVector(relativePosition, -(CPlayer.mo.angle - 90));
;
				// // Console.Printf("%f, %f", a.Vel.x, a.Vel.y);

				DrawImage(friendly ? "FRNDHUD" : "ALNHUD", (offset.x + radarCenter.x, -offset.y + radarCenter.y), DI_SCREEN_LEFT_BOTTOM  | DI_ITEM_LEFT_BOTTOM, 1, (-1, -1), (0.5, 0.5));

				// Console.Printf("Distance to BOB: %d", dist);
			}



 			// let t = FindClosestTarget("Bob1"); // Replace "PlayerPawn" with your desired class
			// if(t != null)
			// {
			// 	//Console.Printf("Target: %s", t.GetClassName());
			// }
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