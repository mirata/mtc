class LevelManager : Thinker
{
    int levelIndex;
    int state;
    int startIndex;

    LevelManager Init() {
        self.state = 0;

        return self;
    }

    static bool IsFinished()
    {
        let levelIndex = Get().levelIndex;
        if(levelIndex == 3) {
            Console.Printf("Level 3 finished state");
            return TagSwitchManager.Get().count >= 3;
        }
        return Get().state == 1;
    }

    static bool IsFailure()
    {
        let levelIndex = Get().levelIndex;
        if(levelIndex == 3) {
            return false;
        }
        return Get().state == 2;
    }

    static void SetFinished()
    {
        Get().state = 1;
    }

    static void SetFailure()
    {
        Get().state = 2;
    }

    static void SetStart(int startIndex) {
        Console.Printf("Setting start index to %d", startIndex);
        Get().startIndex = startIndex;
    }

    static void SetLevelIndex(int levelIndex) {
        Get().levelIndex = levelIndex;
    }

    static LevelManager Get()
    {
        LevelManager m;
        ThinkerIterator it = ThinkerIterator.Create("LevelManager");
        m = LevelManager(it.Next());
        if (m == null)
        {
            m = new("LevelManager").Init();
        }

        return m;
    }
}