class TagSwitchThinker : Thinker {
    
    PlayerPawn player;
    int tagId;
    int levelIndex;
    int tagSwitchIndex;

    array <int> lineIndexes;

    bool isActive;

    TerminalDefinition definition;

    TagSwitchThinker Init(
        int tagId, 
        int levelIndex,
        int tagSwitchIndex) {
        self.tagId = tagId;
        self.levelIndex = levelIndex;
        self.tagSwitchIndex = tagSwitchIndex;
        self.isActive = false;

        for (int i = 0; i < Players.size(); i++) {
            self.player = PlayerPawn(Players[i].mo);
            if (self.player != null) {
                break; // Take the first valid player
            }
        }

        return self;
    }

    void Interact() {
        if(self.isActive) {
            return;
        }

        TagSwitchManager m = TagSwitchManager.Get();
        m.count++;
        Console.Printf("TagSwitch count: %d", m.count);
        
        self.isActive = true;

        Switches.Toggle(self.tagId, true);
    }

    void SetTexture(string texName, string sound) {
        for (int i = 0; i < lineIndexes.size(); i++) {    
            Line line = level.lines[lineIndexes[i]];
            Side side = line.sidedef[Line.front];
            TextureID tex = TexMan.CheckForTexture(texName, TexMan.Type_Any);

            side.SetTexture(Side.mid, tex);
            if(sound != "") {
                line.frontsector.StartSoundSequence(0, sound, 0);
            }
        }
    }
}

class TagSwitchManager : Thinker
{
    int count;

    static TagSwitchManager Get()
    {
        TagSwitchManager m;
        ThinkerIterator it = ThinkerIterator.Create("TagSwitchManager");
        m = TagSwitchManager(it.Next());
        if (m == null)
        {
            m = new("TagSwitchManager");
            m.count = 0;
        }

        return m;
    }
}

class TagSwitch play {
    static void Init(
        int tagId, 
        int levelIndex,
        int tagSwitchIndex) {


        TagSwitchThinker p = GetInstance(tagId);
        if(p == null) {
            p = new ("TagSwitchThinker").Init(
                tagId, 
                levelIndex,
                tagSwitchIndex);
        }
    }

    static void Interact(int tagId) {
        TagSwitchThinker p = GetInstance(tagId);
        if(p != null) {
            p.Interact();
        } else {
            Console.Printf("TagSwitch tag %d does not exist", tagId);
        }
    }

    static TagSwitchThinker GetInstance(int tagId) {
        ThinkerIterator it = ThinkerIterator.Create("TagSwitchThinker");
        TagSwitchThinker p = null;

        while (p = TagSwitchThinker(it.next()))
        {
            if(p.tagId == tagId) {
                //Console.Printf("Found existing thinker for tag %d", tagId);
                return p;
            }
        }
        //Console.Printf("Terminal tag %d does not exist", tagId);
        return null;
    }
}