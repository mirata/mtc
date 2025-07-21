class Switches play {
    static void Toggle(int tagId, bool active){
        Console.Printf("Toggle %d", tagId);
        if(tagId >= 0) {  
            int i;
            array <Line> controlPanelLines;  
                 
            LineIdIterator li = Level.CreateLineIdIterator(tagId);
            while((i = li.Next()) >= 0)
            {
                controlPanelLines.push(level.lines[i]);
            }
                
            for (int i = 0; i < controlPanelLines.size(); i++)
            {
                Line line = controlPanelLines[i];
                Side side = line.sidedef[Line.front];

                // 🔍 Get the current mid texture name
                TextureID currentTex = side.GetTexture(Side.mid);
                String currentTexName = TexMan.GetName(currentTex);
                Console.Printf("Current mid texture: %s", currentTexName);

                if (currentTexName.IndexOf("SET00") >= 0 || currentTexName.IndexOf("SET01") >= 0)
                {
                    if (active)
                    {
                        currentTexName.Replace("01", "00");
                    }
                    else
                    {
                        currentTexName.Replace("00", "01");
                    }
                    
                    TextureID tex = TexMan.CheckForTexture(currentTexName, TexMan.Type_Any);

                    side.SetTexture(Side.mid, tex);
                    line.frontsector.StartSoundSequence(0, active ? "MarathonSwitchOn" : "MarathonSwitchOff", 0);
                    continue;
                }
                

                if (currentTexName.IndexOf("SET02") >= 0 || currentTexName.IndexOf("SET03") >= 0)
                {
                    if (active)
                    {
                        currentTexName.Replace("03", "02");
                    }
                    else
                    {
                        currentTexName.Replace("02", "03");
                    }
                    
                    TextureID tex = TexMan.CheckForTexture(currentTexName, TexMan.Type_Any);

                    side.SetTexture(Side.mid, tex);
                    continue;
                }
                

                if (currentTexName.IndexOf("3SET36") >= 0 || currentTexName.IndexOf("3SET35") >= 0)
                {
                    if (active)
                    {
                        currentTexName.Replace("36", "35");
                    }
                    else
                    {
                        currentTexName.Replace("35", "36");
                    }
                    
                    TextureID tex = TexMan.CheckForTexture(currentTexName, TexMan.Type_Any);

                    side.SetTexture(Side.mid, tex);
                    line.frontsector.StartSoundSequence(0, "Puzzle", 0);
                    continue;
                }

                if (currentTexName.IndexOf("SET37") >= 0 || currentTexName.IndexOf("SET36") >= 0)
                {
                    if (active)
                    {
                        currentTexName.Replace("37", "36");
                    }
                    else
                    {
                        currentTexName.Replace("36", "37");
                    }
                    
                    TextureID tex = TexMan.CheckForTexture(currentTexName, TexMan.Type_Any);

                    side.SetTexture(Side.mid, tex);
                    line.frontsector.StartSoundSequence(0, "Puzzle", 0);
                    continue;
                }
            }
        }
    }
}