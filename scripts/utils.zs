class Utils play {
    
    static void AddUniqueInt(Array<int> arr, int value)
    {
        for (int i = 0; i < arr.size(); i++)
        {
            if (arr[i] == value)
                return; // Already in array, do nothing
        }
        arr.push(value); // Not found, add it
    }

    static bool OverlapsSector(PlayerPawn p, Sector sec)
    {
        if (p.CurSector == sec) return true;

        int SAMPLES = 12;             // 30° increments
        let r = max(4.0, p.radius);

        for (int i = 0; i < 360; i += 360 / SAMPLES)
        {
            let ang = i * (M_PI/180.0);    // radians for cos/sin
            let px = p.Pos.X + cos(ang) * r;
            let py = p.Pos.Y + sin(ang) * r;

            if (Level.PointInSector((px, py)) == sec) // <- key call
                return true;
        }
        return false;
    }
}