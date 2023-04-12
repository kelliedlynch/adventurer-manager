using Godot;
using System;
using System.Collections.Generic;

public class Roster
{
    public List<Hero> Heroes { get; } = new();

    public void AddHero(Hero hero)
    {
        if (Heroes.Contains(hero)) return;
        Heroes.Add(hero);
    }

    public void RemoveHero(Hero hero)
    {
        if (!Heroes.Contains(hero)) return;
        Heroes.Remove(hero);
    }
}
