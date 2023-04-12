using Godot;
using System;
using AdventurerManager.UITheme.Menu;

[Tool]
public partial class HeroRoster : Menu
{
    
    private HBoxContainer _headerContainer = new();
    private Control _portraitColumnSpacer = new();
    private Label _nameColumnLabel = new();
    private Label _hatColumnLabel = new();
    
    public HeroRoster()
    {
        MenuTitle = "Hero Roster";

        // _headerContainer.SizeFlagsHorizontal = SizeFlags.ExpandFill;
        // MenuItemsContainer.AddChild(_headerContainer);
        // _headerContainer.Owner = this;
        //
        // _portraitColumnSpacer.CustomMinimumSize = new Vector2(48, 16);
        // _headerContainer.AddChild(_portraitColumnSpacer);
        // _portraitColumnSpacer.Owner = this;
        //
        // _nameColumnLabel.Text = "Name";
        // _nameColumnLabel.ThemeTypeVariation = "LightText";
        // _nameColumnLabel.Position = new Vector2(48, 0);
        // _headerContainer.AddChild(_nameColumnLabel);
        // _nameColumnLabel.Owner = this;
        //
        // _hatColumnLabel.Text = "Class";
        // _hatColumnLabel.ThemeTypeVariation = "LightText";
        // _headerContainer.AddChild(_hatColumnLabel);
        // _hatColumnLabel.Owner = this;
        
        
        var roster = GenerateDummyRoster();
        foreach (Hero hero in roster.Heroes)
        {
            // var rosterEntry = ResourceLoader.Load<PackedScene>("res://Scenes/HeroRoster/HeroRosterEntry.tscn").Instantiate();
            
            var rosterEntry = new HeroRosterEntry(hero);
            MenuItemsContainer.AddChild(rosterEntry);
            // rosterEntry.Owner = this;
            rosterEntry.AttachToSceneTree(this);
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
}
