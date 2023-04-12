
using System;
using System.Collections.Generic;
using Godot;

public struct HatData
{
   public string Name;
   public int HP;
   public int Atk;
   public int Def;

   public HatData(string hat)
   {
      Name = hat;
      switch (hat)
      {
         case Hats.Fighter:
            // Name = "Fighter";
            HP = 10;
            Atk = 7;
            Def = 5;
            break;
         case Hats.Cleric:
            // Name = "Cleric";
            HP = 9;
            Atk = 5;
            Def = 6;
            break;         
         case Hats.Rogue:
            // Name = "Rogue";
            HP = 8;
            Atk = 6;
            Def = 4;
            break;
         case Hats.Wizard:
            // Name = "Wizard";
            HP = 6;
            Atk = 10;
            Def = 2;
            break;
         default:
            // Name = "No Class";
            HP = 1;
            Atk = 1;
            Def = 1;
            break;
      }
   }

   public override string ToString()
   {
      return Name;
   }
}

// public enum Hats
// {
//    Fighter,
//    Cleric,
//    Rogue,
//    Wizard
// }

public static class Hats
{
   public const string Fighter = "Fighter";
   public const string Cleric = "Cleric";
   public const string Rogue = "Rogue";
   public const string Wizard = "Wizard";
   public static readonly List<string> AllHats = new List<string>() { Fighter, Cleric, Rogue, Wizard };

   public static string RandomHat()
   {
      var rng = new RandomNumberGenerator();
      rng.Randomize();
      var hatPicker = Convert.ToInt32(Math.Floor(rng.Randf() * 4));
      return AllHats[hatPicker];
   }
}