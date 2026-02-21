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

    static bool ContainsInt(Array<int> arr, int value)
    {
        for (int i = 0; i < arr.size(); i++)
        {
            if (arr[i] == value) return true;
        }
        return false;
    }

    static void ClearIntArray(Array<int> arr)
    {
        while (arr.Size() > 0)
        {
            arr.Delete(arr.Size() - 1, 1);
        }
    }

    static bool OverlapsSector(Actor a, Sector sec, int samples = 16, double radiusOverride = 0)
    {
        if (a == null || sec == null) return false;

        // Don't depend on CurSector (player-only); origin sector check is the fast-path.
        if (Level.PointInSector((a.Pos.X, a.Pos.Y)) == sec) return true;

        int SAMPLES = max(8, samples);
        let r = (radiusOverride > 0) ? radiusOverride : max(4.0, a.radius);

        // Sample two rings (outer + inner) to reduce misses when barely clipping a corner.
        for (int ring = 0; ring < 2; ring++)
        {
            let rr = (ring == 0) ? r : (r * 0.60);
            for (int i = 0; i < 360; i += 360 / SAMPLES)
            {
                let ang = i * (M_PI/180.0);    // radians for cos/sin
                let px = a.Pos.X + cos(ang) * rr;
                let py = a.Pos.Y + sin(ang) * rr;

                if (Level.PointInSector((px, py)) == sec) // <- key call
                    return true;
            }
        }
        return false;
    }

    // Fills outSectorIndexes with sector indices the actor's radius overlaps.
    // NOTE: LZDoom ZScript doesn't support returning dynamic arrays, so this uses an output parameter.
    // Implementation uses sampling around the actor's collision radius. This is intentionally a bit
    // conservative and can be tuned via `samples`.
    static void GetOverlappedSectorIndexes(Actor a, Array<int> outSectorIndexes, int samples = 16, int maxDepth = 3, double radiusOverride = 0)
    {
        ClearIntArray(outSectorIndexes);
        if (a == null) return;

        int SAMPLES = max(16, samples);
        let r = (radiusOverride > 0) ? radiusOverride : max(4.0, a.radius);

        // Always include origin sector.
        let originSec = Level.PointInSector((a.Pos.X, a.Pos.Y));
        if (originSec != null) AddUniqueInt(outSectorIndexes, originSec.Index());

        // Sample multiple rings to reduce misses when the overlap is narrow.
        // These fractions are chosen to catch both edge and near-edge clipping.
        for (int ring = 0; ring < 4; ring++)
        {
            let rr = r;
            if (ring == 1) rr = r * 0.75;
            else if (ring == 2) rr = r * 0.50;
            else if (ring == 3) rr = r * 0.25;

            for (int i = 0; i < 360; i += 360 / SAMPLES)
            {
                let ang = i * (M_PI/180.0);
                let px = a.Pos.X + cos(ang) * rr;
                let py = a.Pos.Y + sin(ang) * rr;
                let sec = Level.PointInSector((px, py));
                if (sec != null) AddUniqueInt(outSectorIndexes, sec.Index());
            }
        }

        // Extra cardinal samples at full radius.
        let secX1 = Level.PointInSector((a.Pos.X + r, a.Pos.Y));
        if (secX1 != null) AddUniqueInt(outSectorIndexes, secX1.Index());
        let secX0 = Level.PointInSector((a.Pos.X - r, a.Pos.Y));
        if (secX0 != null) AddUniqueInt(outSectorIndexes, secX0.Index());
        let secY1 = Level.PointInSector((a.Pos.X, a.Pos.Y + r));
        if (secY1 != null) AddUniqueInt(outSectorIndexes, secY1.Index());
        let secY0 = Level.PointInSector((a.Pos.X, a.Pos.Y - r));
        if (secY0 != null) AddUniqueInt(outSectorIndexes, secY0.Index());

        // maxDepth is kept for API compatibility; currently unused by this sampling approach.
    }
}