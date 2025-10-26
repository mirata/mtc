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

        LevelManager.Get().tagSwitchCount++;
        self.player.TakeInventory("DefenseChip", 1);
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

class TagSwitch play {
    static void Init(
        int tagId, 
        int levelIndex,
        int tagSwitchIndex) {

        LevelManager.Get().tagSwitchTotal++;
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