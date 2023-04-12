using Godot;
using System;

[Tool]
public partial class HeroRosterEntry : MenuItem
{
    
    [Export] private int _minColWidth = 76;
    [Export] private int _portraitSize = 48;
    
    private HBoxContainer _entryContainer = new();
    private TextureRect _portrait = new();
    private Control _portraitSpacer = new();
    private Label _nameLabel = new();
    private Label _hatLabel = new();
    private Label _levelLabel = new();

    public HeroRosterEntry()
    {
        _entryContainer.SizeFlagsHorizontal = SizeFlags.ExpandFill;
        _entryContainer.SizeFlagsVertical = SizeFlags.Fill;
        // _entryContainer.CustomMinimumSize = new Vector2(0, 60);
        AddChild(_entryContainer);
        _entryContainer.Owner = this;
        
        _portrait.ExpandMode = TextureRect.ExpandModeEnum.FitHeightProportional;
        _portrait.Size = new Vector2(_portraitSize, _portraitSize);
        _portrait.CustomMinimumSize = new Vector2(_portraitSize, _portraitSize);
        _portrait.SizeFlagsHorizontal = SizeFlags.ShrinkBegin;
        _portrait.SizeFlagsVertical = SizeFlags.ShrinkCenter;
        _entryContainer.AddChild(_portrait);
        _portrait.Owner = this;

        // _portraitSpacer.SizeFlagsHorizontal = SizeFlags.Expand;
        // var spacer = _portraitSize / 2;
        // _portraitSpacer.CustomMinimumSize = new Vector2(spacer, 0);
        // _entryContainer.AddChild(_portraitSpacer);
        // _portraitSpacer.Owner = this;

        // _nameLabel.SizeFlagsHorizontal = SizeFlags.Expand;
        _nameLabel.CustomMinimumSize = new Vector2(_minColWidth, 0);
        _entryContainer.AddChild(_nameLabel);
        _nameLabel.Text = "Name";
        _nameLabel.Owner = this;

        // _hatLabel.SizeFlagsHorizontal = SizeFlags.Expand;
        _hatLabel.Text = "Class";
        _hatLabel.CustomMinimumSize = new Vector2(_minColWidth, 0);
        _entryContainer.AddChild(_hatLabel);
        _hatLabel.Owner = this;

        // _levelLabel.SizeFlagsHorizontal = SizeFlags.Expand;
        _levelLabel.Text = "Lv.";
        _levelLabel.CustomMinimumSize = new Vector2(_minColWidth, 0);
        _entryContainer.AddChild(_levelLabel);
        _levelLabel.Owner = this;

    }
    public HeroRosterEntry(Hero hero) : this()
    {
        _portrait.Texture = GD.Load<Texture2D>(hero.PortraitPath);
        _nameLabel.Text = hero.Name;
        _hatLabel.Text = hero.Hat;
        _levelLabel.Text += " " + hero.Level;

    }

    public void AttachToSceneTree(Node sceneRoot)
    {
        Owner = sceneRoot;
        _entryContainer.Owner = sceneRoot;
        _portrait.Owner = sceneRoot;
        _portraitSpacer.Owner = sceneRoot;
        _nameLabel.Owner = sceneRoot;
        _hatLabel.Owner = sceneRoot;
        _levelLabel.Owner = sceneRoot;
    }
}
