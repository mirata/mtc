class MarathonAutomap : Automap
{
    // Called every frame the automap is visible
    override void DrawOverlay(AutomapEvent e)
    {
        Super.DrawOverlay(e);

        // Example: draw static room labels
        // You will later map these coordinates to Marathon room centers
        DrawRoomLabel("Engineering",  512.0,  128.0, Font.FindFont("SmallFont"), Font.CR_GOLD);
        DrawRoomLabel("Hangar Bay",  -256.0, -512.0, Font.FindFont("SmallFont"), Font.CR_LIGHTBLUE);
    }

    void DrawRoomLabel(String text, double x, double y, Font fnt, int color)
    {
        // Transform world coordinates to automap screen coordinates
        Vector2 mappos = WorldToAutomap(x, y);
        Screen.DrawText(fnt, color, int(mappos.x), int(mappos.y), text, DTA_CleanNoMove, true);
    }

    Vector2 WorldToAutomap(double wx, double wy)
    {
        // Convert world space -> automap space
        // Automap exposes ScaleX/ScaleY and CenterX/CenterY
        double ax = (wx - am_centerx) * am_scalex + am_cx;
        double ay = (wy - am_centery) * am_scaley + am_cy;
        return (ax, ay);
    }
}
