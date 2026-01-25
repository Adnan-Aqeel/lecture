// class categories {
//   var name;
//   var img;
//   var content;
//   var id;

//   categories({
//     this.name,
//     this.img,
//     this.content,
//     this.id,
//   });
//   factory categories.fromJson(Map<String, dynamic> Json) {
//     return categories(
//       name: Json["name"],
//       img: Json["description"],
//       id: Json["id"],
//       content: Json["content"],
//     );
//   }
// }

// class post {
//   var title;
//   var content;
//   var id;
//   post({
//     this.title,
//     this.content,
//     this.id,
//   });
//   factory post.fromJson(Map<String, dynamic> Json) {
//     return post(
//       title: Json["title"]["rendered"],
//       content: Json["content"]["rendered"],
//       id: Json["id"],
//     );
//   }
//   Map<String, dynamic> toMap() {
//     return {
//       'blogID': id,
//       'title': title,
//       'content': content,
//     };
//   }

//   Map<String, dynamic> toprogram() {
//     return {
//       'blogID': id,
//       'title': title,
//       'content': content,
//     };
//   }
// }
class getCategorymodel {
  var name;
  var img;
  var id;
  var slug;
  var count;

  getCategorymodel({
    this.name,
    this.img,
    this.id,
    this.slug,
    this.count,
  });

  factory getCategorymodel.fromJson(Map<String, dynamic> Json) {
    return getCategorymodel(
      name: Json["name"],
      img: Json["description"],
      id: Json["id"],
      slug: Json["slug"],
      count: Json["count"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'blogID': id,
      'name': name,
      'description': img,
      'slug': slug,
    };
  }
}

class getpostsModel {
  var title;
  var content;
  var img;
  var id;
  var slug;
  var count;
  var time;

  getpostsModel({
    this.title,
    this.content,
    this.img,
    this.id,
    this.slug,
    this.count,
    this.time,
    categoryName,
  });

  factory getpostsModel.fromJson(Map<String, dynamic> Json) {
    return getpostsModel(
      title: Json["title"]["rendered"],
      content: Json["content"]["rendered"],
      id: Json["id"],
      count: Json["count"],
      time: Json["time"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'blogID': id,
      'title': title,
      'content': content,
      'img': img,
      //  "categoryName": categoryname,
      //  "CatId": categoryID,
    };
  }

  Map<String, dynamic> toProgramsMap() {
    return {
      'blogID': id,
      'title': title,
      'content': content,
      'img': img,
    };
  }
}
