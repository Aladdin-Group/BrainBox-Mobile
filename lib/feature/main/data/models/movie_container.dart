// ignore_for_file: non_constant_identifier_names

import 'package:brain_box/feature/main/data/models/Movie.dart';
import 'package:brain_box/feature/main/data/models/movie_level.dart';

class MovieContainer{
  static var length = 0;
  static var listBEGINNER = [];
  static var listINTERMEDIATE = [];
  static var listELEMENTARY = [];
  static var listUPPER_INTERMEDIATE = [];
  static addList(Content model){
    length++;
    if(model.level==MovieLevel.BEGINNER){
      listBEGINNER.add(model);
    }else if(model.level==MovieLevel.ELEMENTARY){
      listELEMENTARY.add(model);
    }else if(model.level==MovieLevel.INTERMEDIATE){
      listINTERMEDIATE.add(model);
    }else{
      listUPPER_INTERMEDIATE.add(model);
    }
  }
}