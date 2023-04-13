using Godot;
using System;

[Tool]
public partial class CharacterSheet : PanelContainer
{
    private int _portraitSize = 180;

    private VBoxContainer _sheetContainer;
    private HBoxContainer _headerContainer;
    private TextureRect _portrait;
    private VBoxContainer _headerTextContainer;
    private HBoxContainer _headerTextLine1;
    private Label _nameLabel;
    private Label _levelLabel;
    private Label _hatLabel;
    private HBoxContainer _headerTextLine2;
    private Label _otherInfoLabel;
    private Button _deleteButton;
    private Control _dialogContainer;
    
    public override void _Ready()
    {
        _portrait = FindChild("Portrait", true, false) as TextureRect;
        _nameLabel = FindChild("NameLabel", true, false) as Label;
        _levelLabel = FindChild("LevelLabel", true, false) as Label;
        _hatLabel = FindChild("HatLabel", true, false) as Label;
        _otherInfoLabel = FindChild("OtherInfoLabel", true, false) as Label;
        _deleteButton = FindChild("DeleteButton", true, false) as Button;
        _dialogContainer = FindChild("DialogContainer", true, false) as Control;

        _dialogContainer.CustomMinimumSize = GetViewportRect().Size / 2;
        _dialogContainer.SizeFlagsHorizontal = SizeFlags.ShrinkCenter;
        _dialogContainer.SizeFlagsVertical = SizeFlags.ShrinkCenter;
        
        if (Engine.IsEditorHint())
        {
            var rng = new RandomNumberGenerator();
            var hero = new Hero(Hats.RandomHat());
            hero.Level = rng.RandiRange(1, 8);
            InitWithData(hero);
        }
    }

    public void InitWithData(Hero hero)
    {
        _portrait.Texture = GD.Load<Texture2D>(hero.PortraitPath);
        _nameLabel.Text = hero.Name;
        _levelLabel.Text = "Level " + hero.Level;
        _hatLabel.Text = hero.Hat;
        _otherInfoLabel.Text = "Other information can go here, but I don't know what yet";
        // void PressedEventHandler() => OnDeleteButtonPressed(hero);
        _deleteButton.ButtonDown += () => OnDeleteButtonPressed(hero);
        // _deleteButton.Connect("Pressed", PressedEventHandler);
    }

    private void OnDeleteButtonPressed(Hero hero)
    {
        var scene = ResourceLoader.Load<PackedScene>("res://UITheme/Dialog/Dialog.tscn");
        var dialog = scene.Instantiate<Dialog>();
        _dialogContainer.AddChild(dialog);
        dialog.Owner = this;
    }

    public override void _UnhandledInput(InputEvent @event)
    {
        if (@event is InputEventKey key)
        {
            if (key.Keycode == Key.Escape)
            {
                QueueFree();
            }
        }
    }
}
