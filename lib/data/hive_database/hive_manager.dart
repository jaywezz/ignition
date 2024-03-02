

// All Hive Operations
import 'package:hive_flutter/hive_flutter.dart';

class HiveDataManager{
  final String boxName;

  HiveDataManager(this.boxName);

  //Add hive data
  addHiveData(var data) async{
    try{
      await Hive.openBox(boxName);
      Box _hiveBox = Hive.box(boxName);

      //delete existing data and add the new data to an offline db;
      _hiveBox.deleteAll(_hiveBox.keys);
      print("boxname: $boxName, data ${data}");
      _hiveBox.put(boxName, data);
      print("leads from db ${ _hiveBox.get(boxName)}" );
    }catch(e){
      print(e);
    }
  }

  //Get hive data
  Future<Box> getHiveData()async{
    await Hive.openBox(boxName);
    print("the box name: $boxName");
    Box _hiveBox = Hive.box(boxName);

    return _hiveBox;
  }

  updateHiveData(){
    //Update offline data
  }
}