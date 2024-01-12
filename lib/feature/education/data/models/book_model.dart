class BookModel {

  String  image;
  String name;
  Essential essential;

  BookModel({required this.essential,required this.image,required this.name});

}

enum Essential {
  essential_1,
  essential_2,
  essential_3,
  essential_4,
  essential_5,
  essential_6,
}