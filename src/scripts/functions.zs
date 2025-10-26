class SpecialActionRunner play
{
    static void RunActorSpecialAction(int tag)
    {
        Console.Printf("RunActorSpecialAction(%d)\n", tag);
        SectorTagIterator sti = level.CreateSectorTagIterator(tag);
        int i;
        while((i = sti.Next()) >= 0)
        {
            //Console.Printf("%d", level.sectors[i].floorplane.Zat0());
            level.sectors[i].MoveFloor(0.005, -128, 0, 1, false, false);
        }
    }
}