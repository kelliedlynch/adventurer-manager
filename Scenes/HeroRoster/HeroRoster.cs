using Godot;
using System;
using AdventurerManager.UITheme.Menu;

[Tool]
public partial class HeroRoster : Menu
{
    public override void _Ready()
    {
        base._Ready();
        MenuTitle = "Hero Roster";
        var roster = GenerateDummyRoster();
        var scene = ResourceLoader.Load<PackedScene>("res://Scenes/HeroRoster/HeroRosterEntry.tscn");
        foreach (Hero hero in roster.Heroes)
        {
            var rosterEntry = scene.Instantiate<HeroRosterEntry>();
            MenuItemsContainer.AddChild(rosterEntry);
            rosterEntry.LoadHeroData(hero);
            rosterEntry.Owner = this;
            void MenuItemWasClickedEventHandler() => OnRosterEntryClicked(hero);
            rosterEntry.MenuItemWasClicked += MenuItemWasClickedEventHandler;
        }
        
    }

    private static Roster GenerateDummyRoster(int qty = 9)
    {
        var rng = new RandomNumberGenerator();
        var roster = new Roster();
        for (var i = 0; i < qty; i++)
        {
            var hero = new Hero(Hats.RandomHat());
            hero.Level = rng.RandiRange(1, 8);
            roster.AddHero(hero);
        }

        return roster;
    }

    private void OnRosterEntryClicked(Hero hero)
    {
        GD.Print("RosterEntryWasClicked " + hero.Name);
        var scene = ResourceLoader.Load<PackedScene>("res://Scenes/CharacterSheet/CharacterSheet.tscn");
        var charSheet = scene.Instantiate<CharacterSheet>();
        AddChild(charSheet);
        charSheet.Owner = this;
        charSheet.InitWithData(hero);
        charSheet.Name = "CharacterSheet";
    }

    public override void _UnhandledInput(InputEvent @event)
    {
        // if (@event is InputEventMouseButton button)
        // {
        //     if (button.ButtonIndex == MouseButton.Left && button.IsPressed())
        //     {
        //         GD.Print("Input");
        //     }
        // }
        if (@event is InputEventKey key)
        {
            if (key.Keycode == Key.Escape)
            {
                // var sheet = FindChild("CharacterSheet", true, false);
                // sheet.QueueFree();
            }
        }
    }
}
