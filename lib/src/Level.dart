part of runner;

class Level {

  int speed;
  List<Block> blockList_static;
  List<Block> blockList_dynamic;
  Spawn spawn;

  Level(String jsonString) {
    List<Block> blockList_static = new List<Block>();
    List<Block> blockList_dynamic = new List<Block>();

    try {
      Map jsonData = JSON.decode(jsonString);
      var lvlspwn = jsonData["spawn"];
      this.spawn = new Spawn(0, lvlspwn["pos_x"], lvlspwn["pos_y"], lvlspwn["size_x"], lvlspwn["size_y"]);

      var blocks = jsonData["blocks"];
      if (blocks != null) {
        for (Map m in jsonData["blocks"]) {
          switch (m["type"]) {
            case "Ground":
              var newGround = new Ground(
                  blockList_static.length, m["pos_x"], m["pos_y"], m["size_x"],
                  m["size_y"]);
              blockList_static.add(newGround);
              break;

            case "Wall":
              var newWall = new Wall(
                  blockList_static.length, m["pos_x"], m["pos_y"], m["size_x"],
                  m["size_y"]);
              blockList_static.add(newWall);
              break;

            case "Cobble":
              var newCobble = new Cobble(
                  blockList_static.length, m["pos_x"], m["pos_y"], m["size_x"],
                  m["size_y"]);
              blockList_static.add(newCobble);
              break;

            case "Finish":
              var newFinish = new Finish(
                  blockList_static.length, m["pos_x"], m["pos_y"], m["size_x"],
                  m["size_y"]);
              blockList_static.add(newFinish);
              break;

            case "Water":
              var newWater = new Water(
                  blockList_static.length, m["pos_x"], m["pos_y"], m["size_x"],
                  m["size_y"]);
              blockList_static.add(newWater);
              break;

            case "Coin":
              var newCoin = new Coin(
                  blockList_dynamic.length ?? 0, m["pos_x"], m["pos_y"], m["size_x"],
                  m["size_y"], m["value"] ?? 0);
              blockList_dynamic.add(newCoin);
              break;

            case "Teleport":
              var b = m["target"];

              var newSpawn = new Spawn(
                  blockList_static.length, b["pos_x"], b["pos_y"], b["size_x"],
                  b["size_y"]);
              blockList_static.add(newSpawn);

              var newTeleport = new Teleport(blockList_static.length, m["pos_x"], m["pos_y"], m["size_x"],
                  m["size_y"], newSpawn);
              blockList_static.add(newTeleport);
              break;


            case "Trigger":
              var b = m["bullet"];

              var newBullet = new Bullet(
                  blockList_dynamic.length ?? 0, b["pos_x"], b["pos_y"], b["size_x"],
                  b["size_y"]);
              log(newBullet.toString());
              blockList_dynamic.add(newBullet);

              var newTrigger = new Trigger(
                  blockList_static.length, m["pos_x"], m["pos_y"], m["size_x"],
                  m["size_y"], newBullet);
              log(newTrigger.toString());
              blockList_static.add(newTrigger);
              break;
          }
        }
      }

      // sort this to "accept" bad ordering in levels
      blockList_static.sort((a, b) => a.pos_x.compareTo(b.pos_x));
      blockList_dynamic.sort((a, b) => a.pos_x.compareTo(b.pos_x));
      this.blockList_static = new List<Block>.from(blockList_static, growable: false);
      this.blockList_dynamic = new List<Block>.from(blockList_dynamic, growable: false);
      blockList_dynamic = null;
      blockList_static = null;
    } catch (e, ex) {
      print(e);
      print(ex);
    }

  }

}