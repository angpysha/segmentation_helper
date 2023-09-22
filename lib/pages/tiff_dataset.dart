class TiffDataset {

  TiffDataset({List<String>? categories, List<ImagePart>? items}) {
    if (categories != null) {
      this.categories = categories;
    }

    if (items != null) {
      this.items = items;
    }
  }

  List<String> categories = [];

  List<ImagePart> items = [];

  // Convert a TiffDataset object into a Map
  Map<String, dynamic> toJson() {
    return {
      'categories': categories,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  // Convert a Map into a TiffDataset object
  factory TiffDataset.fromJson(Map<String, dynamic> json) {
    var itemsJson = json['items'] as List;
    List<ImagePart> itemsList = itemsJson.map((i) => ImagePart.fromJson(i)).toList();

    return TiffDataset(
      categories: List<String>.from(json['categories']),
      items: itemsList,
    );
  }
}

class ImagePart {
  const ImagePart(this.width, this.height, this.left, this.top, this.category);

  final String category;
  final double width;
  final double height;
  final double top;
  final double left;

  // Convert an ImagePart object into a Map
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'width': width,
      'height': height,
      'top': top,
      'left': left,
    };
  }

  // Convert a Map into an ImagePart object
  factory ImagePart.fromJson(Map<String, dynamic> json) {
    return ImagePart(
      json['width'] as double,
      json['height'] as double,
      json['left'] as double,
      json['top'] as double,
      json['category'] as String,
    );
  }
}