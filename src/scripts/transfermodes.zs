class TextureThinker : Thinker {
    int tagId;
    string position;
    string type;
    array<SideDefinition> sideDefinitions;

    int sideWhich;

    array<int> sectorIndexes;
    array<int> lineIndexes;

    int ticks;

    TextureThinker Init(
        int tagId,
        string position,
        string type) {
        self.tagId = tagId;
        self.position = position;
        self.type = type;

        self.sideWhich = GetSideType(position);
        self.ticks = 0;

        if(position == "Floor" || position == "Ceiling") {
            SectorTagIterator sti = level.CreateSectorTagIterator(tagId);
            int i;

            while((i = sti.Next()) >= 0)
            {
                self.sectorIndexes.Push(i);
            }
        } else {
            LineIdIterator li = level.CreateLineIdIterator(tagId);
            int i;

            while((i = li.Next()) >= 0)
            {
                self.lineIndexes.Push(i);
            }
        }

        return self;
    }

    override void Tick() {
        // floors/ceilings
        if(sectorIndexes.Size() > 0) {
            for(int i=0;i<sectorIndexes.Size(); i++){
                Sector s = level.sectors[sectorIndexes[i]];
                let off = s.GetXOffset(0);
                off += 0.2;
                s.SetXOffset(0, off);
            }
        }

        // walls
        if(lineIndexes.Size() > 0) {
            for(int i = 0; i < lineIndexes.Size(); i++) {
                Line line = level.lines[lineIndexes[i]];

                if (type == "Pulsate") {

                }
                else if (type == "Wobble") {
                    double val = Sin(double(ticks) / 3 * 180 - 90) / 2 + 0.5;
                    if(line.sidedef[0] != null) {
                        let side = line.sidedef[0];
                        let scale = (val * 0.05) + 1.0;
                        Console.Printf("Scale: %f", scale);
                        side.SetTextureXScale(sideWhich, scale);
                        side.SetTextureYScale(sideWhich, scale);
                    };
                    if(line.sidedef[1] != null) {
                        let side = line.sidedef[1];
                        let scale = (val * 0.05) + 1.0;
                        side.SetTextureXScale(sideWhich, scale);
                        side.SetTextureYScale(sideWhich, scale);
                    }
                }
                else if (type == "FastWobble") {           
                    double val = Sin(double(ticks) / 1.5 * 180 - 90) / 2 + 0.5;
                    if(line.sidedef[0] != null) {
                        let side = line.sidedef[0];
                        let scale = (val * 0.05) + 1.0;
                        Console.Printf("Scale: %f", scale);
                        side.SetTextureXScale(sideWhich, scale);
                        side.SetTextureYScale(sideWhich, scale);
                    };
                    if(line.sidedef[1] != null) {
                        let side = line.sidedef[1];
                        let scale = (val * 0.05) + 1.0;
                        side.SetTextureXScale(sideWhich, scale);
                        side.SetTextureYScale(sideWhich, scale);
                    }
                }
                else if (type == "HorizontalSlide") {
                    if(line.sidedef[0] != null) {
                        let side = line.sidedef[0];
                        let off = side.GetTextureXOffset(sideWhich);
                        off -= 0.1;
                        side.SetTextureXOffset(sideWhich, off);
                    };
                    if(line.sidedef[1] != null) {
                        let side = line.sidedef[1];
                        let off = side.GetTextureXOffset(sideWhich);
                        off -= 0.1;
                        side.SetTextureXOffset(sideWhich, off);
                    }
                }
                else if (type == "FastHorizontalSlide") {

                }
                else if (type == "VerticalSlide") {
                    if(line.sidedef[0] != null) {
                        let side = line.sidedef[0];
                        let off = side.GetTextureYOffset(sideWhich);
                        off -= 0.1;
                        side.SetTextureYOffset(sideWhich, off);
                    };
                    if(line.sidedef[1] != null) {
                        let side = line.sidedef[1];
                        let off = side.GetTextureYOffset(sideWhich);
                        off -= 0.1;
                        side.SetTextureYOffset(sideWhich, off);
                    }
                }
                else if (type == "FastVerticalSlide") {

                }
                else if (type == "Wander") {

                }
                else if (type == "FastWander") {

                }

            }
        }

        self.ticks++;
    }
    
    int GetSideType(string position) {
        if(position == "Upper") {
            return Side.top;
        }
        else if(position == "Middle") {
            return Side.mid;
        }
        else if(position == "Lower") {
            return Side.bottom;
        }
        return Side.mid;
    }
}

class SideDefinition{
    int sectorIndex;
    int sideIndex;

    SideDefinition Init(int sectorIndex, int sideIndex) {
        self.sectorIndex = sectorIndex;
        self.sideIndex = sideIndex;

        return self;
    }
}

class Transfer play {
    static void Init(
        int tagId, 
        string position,
        string type) {
        TextureThinker p = GetInstance(tagId);
        if(p == null) {
            new ("TextureThinker").Init(
                tagId, 
                position,
                type);
        }
    }

    static TextureThinker GetInstance(int tagId) {
        ThinkerIterator it = ThinkerIterator.Create("TextureThinker");
        TextureThinker p = null;

        while (p = TextureThinker(it.next()))
        {
            if(p.tagId == tagId) {
                //Console.Printf("Found existing thinker for tag %d", tagId);
                return p;
            }
        }
        //Console.Printf("Texture tag %d does not exist", tagId);
        return null;
    }
}

// TransferModes["normal"]._short = "normal"
// TransferModes["pulsate"]._short = "pulsate"
// TransferModes["wobble"]._short = "wobble"
// TransferModes["fast wobble"]._short = "f wobble"
// TransferModes["landscape"]._short = "landscap"
// TransferModes["horizontal slide"]._short = "h slide"
// TransferModes["fast horizontal slide"]._short = "fh slide"
// TransferModes["vertical slide"]._short = "v slide"
// TransferModes["fast vertical slide"]._short = "fv slide"
// TransferModes["wander"]._short = "wander"
// TransferModes["fast wander"]._short = "f wander"
// TransferModes["static"]._short = "static"
// TransferModes["reverse horizontal slide"]._short = "h sl r"
// TransferModes["reverse fast horizontal slide"]._short = "fh sl r"
// TransferModes["reverse vertical slide"]._short = "v sl r"
// TransferModes["reverse fast vertical slide"]._short = "fv sl r"
// TransferModes["2x"]._short = "2x"
// TransferModes["4x"]._short = "4x"