# Changelog

## [0.10.1] - 2025-04-15

1. Complete move + stick feature of smithy element;

## [0.10.0] - 2025-04-14

1. Begin to work with smithy;

## [0.9.2] - 2025-04-13

1. Little refactoring;
2. Complete making of research;

## [0.9.1] - 2025-04-12

1. Little refactoring;
2. Add connections between nodes with line depend from the distance;

## [0.9.0] - 2025-04-12

1. Start to work with table and aspects on table;

## [0.8.4] - 2025-04-09

1. Add new spell, prolong ray;
2. Add new feature of prolong spell, and add support of that spell type;

## [0.8.3] - 2025-04-09

1. Add new spell, mini line queue;

## [0.8.2] - 2025-04-08

1. Add 2 spells, arc and line, and create for this spell logic of this spell;

## [0.8.1] - 2025-03-31

1. Create SpellWorker;
2. Complete feature which allow to make a damage from first spell;
3. Update spell behavior;

## [0.8.0] - 2025-03-29

1. Add new entities: Aspect, Spell, AspectsWorker;
2. Begin to refactoring of aspects work;
3. Begin to work with spells;

## [0.7.0] - 2025-03-25

1. Add new entity - item;
2. Add 2 types of inventories;
3. This additions made without any connection logic;

## [0.6.0] - 2025-03-23 !! My birthday !! (happy smile)

1. Add inventory entity, begin to develop it.
2. Begin to little refactoring of scenes file positions;

## [0.5.0] - 2025-03-23 !! My birthday !! (happy smile)

1. Add entity attiributes, and worker for that. It's only beggining of this mechanic;
2. Little refactoring of other elements of game;

## [0.4.0] - 2025-03-21

1. Fully complete at this moment with dialog system.
   Business logic and game mechanic is the same right now.
   Description of business logic:

   - Player can choice between 1 - 4 answers
   - Any answer can make some world change. For example:
     - add attribute to player;
     - make some action like open the shop;
     - start the quest;
     - open new mechanic for player;
     - and other...
   - Any answer can have some conditions for represent, examples:
     _ need some attribute;
     _ some active quest;
     _ some active mechanic;
     _ and other.
     Description of this mechanic in game:
   - On intput we can send some params for represent some answers.
     For example, if you have quest, attribute or something for answer,
     game show this answer to player.
   - If player choice some answer, like in input, we can setup some params,
     it can be attributes, quests, or something like that.
   - In near future it can be a little refactorize,
     because in near feature will be complete quest mechanic.

2. Begin to work with quests mechanic:
   Description of business logic:
   - Begin of quest.
   - Quest has some steps:
     - first is hunt for X;
     - second learn new spell;
     - heal the npc;
     - return with report to Y npc;
   - Quest can have some status:
     _ completed;
     _ failed - if something went wrong, for example kill need npc, or somethin like that (maybe something more beatiful, give npc not correct potion and etc.);
     _ active;
     _ not active;
     Description of this mechanic in game:
   - Player can start and complete quest
   - Quest have some progression, for example, deal 5 damage to some entity
     Not added:
     - steps

## [0.2.3] - 2025-01-21

Since the last report, I improved a basic finite state machine for proper chasing behavior, enhanced the overall state of the project, learned how to work with raycasts, implemented peaceful behavior for NPCs, and started working on a dialogue system with support for multiple locales to enable writing for several languages at once.

## [0.2.2] - 2024-11-28

### Added

- Collisions to attack animation
- Logic to separate attack with moving animation

## [0.2.1] - 2024-11-26

### Added

- Enemy vision zone for future debug of enemy vision;
- Start with some correction for animations;
- Start of working with attack action;

## [0.2.0] - 2024-11-23

### Added

- Attack animation;

## [0.1.0] - until 2024-11-23

### Added

- Alchemy elements creation feature;
- Map with tiles;
- Animation of walking on two axis;
- Enemy following algorithm;
