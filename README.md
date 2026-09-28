# AutoAcceptQuestsForever

World of Warcraft Forever addon that automatically accepts quests from NPCs.

## What it does

- **Quest text shown:** accepts the quest, just like clicking **Accept**.
- **NPC with a list of quests** (gossip menu or quest greeting): opens each available quest in turn and accepts it.

It doesn't turn in quests or pick rewards.

These are left to you, the same way Blizzard asks before accepting them:

- Quests that flag you for PvP.
- Quests started from an item (they show as a popup in the objective tracker).
- Quests from the adventure map.
- Quests you've marked as ignored.

## Installation

Copy the `AutoAcceptQuestsForever` folder to the `Interface/AddOns/` folder of your WoW Forever client and restart the game.

## Commands

| Command                         | Description                        |
| ------------------------------- | ---------------------------------- |
| `/aaq` (or `/autoacceptquests`) | Turn automatic accepting on or off |

The setting is saved per account in `AutoAcceptQuestsForeverDB`. It's on by default.
