using System;
using System.Collections.Generic;
using Godot;

public class Hero
{
    public string Name = "";
    public string Hat;
    public int Level;
    public int HP;
    public int Atk;
    public int Def;
    public string PortraitPath;

    public Hero(string hat)
    {
        Name = NameGen.RandomName();
        var hatData = new HatData(hat);
        Hat = hat;
        Level = 1;
        HP = hatData.HP;
        Atk = hatData.Atk;
        Def = hatData.Def;
        PortraitPath = "res://Assets/Images/HeroPortraits/" + Hat.ToLower() + "_portrait.png";

    }
}

public static class NameGen
{
    private static RandomNumberGenerator _gen = new RandomNumberGenerator();

    public static string RandomName()
    {
        var index = _gen.RandiRange(0, _names.Count - 1);
        return _names[index];
    }

    private static List<string> _names = new List<string>()
    {
        "Riley", "River", "Rowan", "Avery", "Jordan", "Quinn", "Elliott", "Sage", "Reese", "Charlie", "Blake", "Remi",
        "Phoenix", "Oakley", "Taylor", "Morgan", "Alexis", "London", "Wren", "Ari", "Ali", "Aspen", "Lennox", "Rylan",
        "Haven", "Briar", "Harley", "Spencer", "Salem", "Noel", "Sam", "Cam", "Alex", "Drew", "Skye", "Casey", "Jamie",
        "Sloan", "Robin", "Jessie", "Ellison", "Rey", "Chris"
    };
}