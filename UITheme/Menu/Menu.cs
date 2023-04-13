using Godot;
using MonoCustomResourceRegistry;

namespace AdventurerManager.UITheme.Menu;

[Tool]
[RegisteredType(nameof(Menu), "", nameof(PanelContainer))]
public partial class Menu : PanelContainer
{
	private string _menuTitle = "Menu Title";
	[Export] public string MenuTitle
	{
		get => _menuTitle;
		set
		{
			_menuTitle = value;
			EmitSignal(SignalName.MenuTitleChanged, value);
		}
	}
	[Signal]
	public delegate void MenuTitleChangedEventHandler(string newTitle);

	private bool _showTitle = true;
	[Export] public bool ShowTitle
	{
		get => _showTitle;
		set
		{
			_showTitle = value;
			EmitSignal(SignalName.ShowTitleChanged, value);
		}
	}
	[Signal]
	public delegate void ShowTitleChangedEventHandler(bool isVisible);
	
	private VBoxContainer _menuOuterContainer;
	private Label _menuTitleLabel;

	private ScrollContainer _menuBodyContainer;
	protected VBoxContainer MenuItemsContainer;

	public Menu()
	{
		Theme = ResourceLoader.Load<Theme>(ResourcePath.Theme);

		// _menuOuterContainer.SizeFlagsHorizontal = SizeFlags.ExpandFill;
		// _menuOuterContainer.SizeFlagsVertical = SizeFlags.ExpandFill;
		// AddChild(_menuOuterContainer);
		// _menuOuterContainer.Owner = this;
		// _menuOuterContainer.Name = "MenuOuterContainer";

		// _menuTitleLabel.Text = _menuTitle;
		// _menuTitleLabel.SizeFlagsHorizontal = SizeFlags.ShrinkCenter;
		// // _menuTitleLabel.SizeFlagsVertical = SizeFlags.Expand;
		// // _menuTitleLabel.Position = Vector2.Zero;
		// _menuTitleLabel.ThemeTypeVariation = "LightText";
		// _menuOuterContainer.AddChild(_menuTitleLabel);
		// _menuTitleLabel.Owner = this;
		// _menuTitleLabel.Name = "MenuTitleLabel";


		
		// _menuBodyContainer.SizeFlagsHorizontal = SizeFlags.ExpandFill;
		// _menuBodyContainer.SizeFlagsVertical = SizeFlags.ExpandFill;
		// // var stylebox = ResourceLoader.Load<StyleBox>(ResourcePath.Content.Medium);
		// // _menuBodyContainer.AddThemeStyleboxOverride("panel", stylebox);
		// _menuOuterContainer.AddChild(_menuBodyContainer);
		// _menuBodyContainer.Owner = this;
		// _menuBodyContainer.Name = "MenuBodyContainer";

		// MenuItemsContainer.SizeFlagsHorizontal = SizeFlags.ExpandFill;
		// MenuItemsContainer.SizeFlagsVertical = SizeFlags.ExpandFill;
		// _menuBodyContainer.AddChild(MenuItemsContainer);
		// MenuItemsContainer.Owner = this;
		// MenuItemsContainer.Name = "MenuItemsContainer";

		// for (var i = 0; i < 5; i++)
		// {
		// 	var menuItem = new MenuItem();
		// 	menuItem.Owner = this;
		// 	_menuBodyContainer.AddChild(menuItem);
		// 	
		// 	menuItem.Name = "MenuItem " + i; 
		// 	
		// }

	}

	public void OnMenuTitleChanged(string newTitle)
	{
		_menuTitleLabel.Text = newTitle;
	}
	
	public void OnShowTitleChanged(bool isVisible)
	{
		_menuTitleLabel.Visible = isVisible;
	}
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		_menuOuterContainer = FindChild("MenuOuterContainer", true, false) as VBoxContainer;
		_menuTitleLabel = FindChild("MenuTitleLabel", true, false) as Label;
		_menuBodyContainer = FindChild("MenuBodyContainer", true, false) as ScrollContainer;
		MenuItemsContainer = FindChild("MenuItemsContainer", true, false) as VBoxContainer;

		foreach (Node node in MenuItemsContainer.GetChildren())
		{
			node.QueueFree();
		}
		
		MenuTitleChanged += OnMenuTitleChanged;
		ShowTitleChanged += OnShowTitleChanged;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}