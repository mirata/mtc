class SpecialActionRunner play
{
    static void RunActorSpecialAction(int tag)
    {
        SectorTagIterator sti = level.CreateSectorTagIterator(tag);
        int i;
        while((i = sti.Next()) >= 0)
        {
            level.sectors[i].SetPlaneLight(0, 0);
        }
    }
}