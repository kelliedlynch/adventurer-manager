using Godot;
using System;

[Tool]
public partial class HeroRosterEntry : MenuItem
{

    private int _minColWidth = 76;

    [Export]
    public int MinColumnWidth
    {
        get => _minColWidth;
        set
        {
            _minColWidth = value;
            EmitSignal("MinimumColumnWidthChanged", value);
        }
    }

    [Signal]
    public delegate void MinimumColumnWidthChangedEventHandler(int newValue);

    private int _portraitSize = 48;

    [Export]
    public int PortraitSize
    {
        get => _portraitSize;
        set
        {
            _portraitSize = value;
            EmitSignal("PortraitSizeChanged", value);
        }
    }

    [Signal]
    public delegate void PortraitSizeChangedEventHandler(int newValue);

    private TextureRect _portrait;
    private Label _nameLabel;
    private Label _hatLabel;
    private Label _levelLabel;

    public override void _Ready()
    {
        var test = FindChild("Portrait", true, false);
        _portrait = FindChild("Portrait", true, false) as TextureRect;
        _nameLabel = FindChild("NameLabel", true, false) as Label;
        _hatLabel = FindChild("HatLabel", true, false) as Label;
        _levelLabel = FindChild("LevelLabel", true, false) as Label;

        _portrait.Texture = GD.Load<Texture2D>("res://Assets/Images/HeroPortraits/blank_portrait.png");
        
        PortraitSizeChanged += OnPortraitSizeChanged;
        MinimumColumnWidthChanged += OnMinimumColumnWidthChanged;
        EmitSignal("PortraitSizeChanged", _portraitSize);
        EmitSignal("MinimumColumnWidthChanged", _minColWidth);
    }
    public void LoadHeroData(Hero hero)
    {
        _portrait.Texture = GD.Load<Texture2D>(hero.PortraitPath);
        _nameLabel.Text = hero.Name;
        _hatLabel.Text = hero.Hat;
        _levelLabel.Text = "Lv. " + hero.Level;

    }
    
    private void OnMinimumColumnWidthChanged(int newVal)
    {
        var size = new Vector2(newVal, 0);
        _nameLabel.CustomMinimumSize = size;
        _hatLabel.CustomMinimumSize = size;
        _levelLabel.CustomMinimumSize = size;
    }

    private void OnPortraitSizeChanged(int newVal)
    {
        var size = new Vector2(newVal, newVal);
        _portrait.Size = size;
        _portrait.CustomMinimumSize = size;
    }
    

}
