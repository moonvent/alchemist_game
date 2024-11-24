# Alchemist

## About

Game work on Godot 4.3

## State Log

* State on 28.07.2024: https://youtu.be/8ys3l1ou1Bg
* State on 16.11.2024: https://youtu.be/r8zgBmNLmKo


## Roadmap

### Points

- [x] Make brain for enemies and villagers
  - [ ] Make following for the main character from enemy if they see him, if enemy doesn't see the main hero, 
  it going to the last point where see them and start to explore terrain, search the corners and some this logic
  - [ ] Villagers need just live, they can to make some actions in their home, out from home, going to the market, speak with other npc
- [ ] Add some scenario for the game
  - [ ] Make dialog scenes and scripts
  - [ ] Make quest scripts
- [ ] Add system of inventory or something like that
  - [ ] The main hero can learn some alchemy aspects [1]
  - [ ] The main hero can make some researches from the aspects [2]
  - [ ] Make feature of learning researches [3]
- [ ] Make the battle system, for beggining we need just sword moving, if enemy near with main hero they attack him, 
if near the villager logic the same, but villagers can attack enemies to.
  - [ ] Make deeper system, add some alchemist features for battle process


### Descriptions for references

[1] Aspects can be merge in more difficult aspects, for example: fire + air = light

[2] For example, to make the Iron he need to make some actions, create the researche from the book,
place it on the learning table, and connect to or more point in one line.

[3] Make the feature for learning, for example, one element will be in left side, one in right side,
after that we need to add to the element from one of side the aspect, which contain connect aspect or
make from it. For example, we have left side the iron, iron consist from earth and fire, it's mean, we 
can connect to iron fire or earth, and in other side it's work, if some element consist iron, for example 
the armor, we can connect armor to iron cause iron consist in armor.

All on the field, if we can define the table with aspects as a field, will be a few pathes, for example some 
easy research will have a one start element from left and one from right, okay, but, if we learn some difficult
research, we can have 5 elements from right side and 5 from left. And when player try to connect to one element a 
few other elements it can be not possible, cause one element can connect to others if it can probability of weight. 
For example, the iron consist from earth and fire, that mean if earth connect to iron one time, we can't connect to 
iron earth another time, cause this element consist one earth and one fire, we can connect fire to iron and if 
iron connected to fire and earth, it can't be connect to fire or earth again, but can be connected to element
which consist iron, in our case it's armor. (But think about this logic, it can be hard or boring)

Target of it, it's a connect elements from right sides to left sides, one element can plase near other, 
and if this elements connected, they add some backlight and make a little line between them, and actually,
every element has a radius to connect to other element, if element not connect to other, them has a little
dimming.
