using Godot;
using System;

[Tool]
public partial class CharacterSheet : PanelContainer
{
    private int _portraitSize = 180;

    private VBoxContainer _sheetContainer = new();
    private HBoxContainer _headerContainer = new();
    private TextureRect _portrait = new();
    private VBoxContainer _headerTextContainer = new();
    private HBoxContainer _headerTextLine1 = new();
    private Label _nameLabel = new();
    private Label _levelLabel = new();
    private Label _hatLabel = new();
    private HBoxContainer _headerTextLine2 = new();
    private Label _otherInfoLabel = new();
    

    public CharacterSheet()
    {
        _sheetContainer.SizeFlagsHorizontal = SizeFlags.ExpandFill;
        _sheetContainer.SizeFlagsVertical = SizeFlags.ExpandFill;
        AddChild(_sheetContainer);
        _sheetContainer.Owner = this;

        _headerContainer.SizeFlagsHorizontal = SizeFlags.ExpandFill;
        _sheetContainer.AddChild(_headerContainer);
        _headerContainer.Owner = this;
        
        _portrait.ExpandMode = TextureRect.ExpandModeEnum.FitHeightProportional;
        _portrait.Size = new Vector2(_portraitSize, _portraitSize);
        _portrait.CustomMinimumSize = new Vector2(_portraitSize, _portraitSize);
        _portrait.SizeFlagsHorizontal = SizeFlags.ShrinkBegin;
        _portrait.SizeFlagsVertical = SizeFlags.ShrinkCenter;
        _headerContainer.AddChild(_portrait);
        _portrait.Owner = this;

        _headerTextContainer.SizeFlagsHorizontal = SizeFlags.ExpandFill;
        _headerContainer.AddChild(_headerTextContainer);
        _headerTextContainer.Owner = this;

        _headerTextLine1.SizeFlagsHorizontal = SizeFlags.ExpandFill;
        _headerTextContainer.AddChild(_headerTextLine1);
        _headerTextLine1.Owner = this;

        _nameLabel.SizeFlagsHorizontal = SizeFlags.ExpandFill;
        _headerTextLine1.AddChild(_nameLabel);
        _nameLabel.Owner = this;

        _levelLabel.SizeFlagsHorizontal = SizeFlags.ShrinkEnd;
        _headerTextLine1.AddChild(_levelLabel);
        _levelLabel.Owner = this;
        
        _hatLabel.SizeFlagsHorizontal = SizeFlags.ExpandFill;
        _headerTextLine1.AddChild(_hatLabel);
        _hatLabel.Owner = this;
        
        _headerTextLine2.SizeFlagsHorizontal = SizeFlags.ExpandFill;
        _headerTextContainer.AddChild(_headerTextLine2);
        _headerTextLine2.Owner = this;

        _otherInfoLabel.SizeFlagsHorizontal = SizeFlags.ExpandFill;
        _headerTextLine2.AddChild(_otherInfoLabel);
        _otherInfoLabel.Owner = this;

        if (Engine.IsEditorHint())
        {
            var rng = new RandomNumberGenerator();
            var hero = new Hero(Hats.RandomHat());
            hero.Level = rng.RandiRange(1, 8);
            InitWithData(hero);
        }
    }
    
    public CharacterSheet(Hero hero) : this()
    {
        InitWithData(hero);
    }

    private void InitWithData(Hero hero)
    {
        _portrait.Texture = GD.Load<Texture2D>(hero.PortraitPath);
        _nameLabel.Text = hero.Name;
        _levelLabel.Text = "Level " + hero.Level;
        _hatLabel.Text = hero.Hat;
        _otherInfoLabel.Text = "Other information can go here, but I don't know what yet";
    }
}
