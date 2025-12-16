class AddProductModel {
  String? product_id = "";

  String? categoryId = "";
  String? subCategoryId = "";
  String? childCategoryId = "";
  String? hsnNo = "";
  //String? isPopular;
  String? isTaxable = "";
  String? taxValue = "";
  String? sameSayDelivery = "";
  String? brandId = "";
  String? name = "";
  String? description = "";
  String? fullDescription = "";
  String? deliveryDay = "";
  String? images = "";
  String? default_image = "";
  String? attribute_ids = "";
  List<VariationsQuantity>? variationsQuantity;
  List<Specifactions>? specifactions;

  String? bransName;
  String? categoryName;
  String? subCategoryName;
  String? childCategoryName;
  String? cash_on_delivery;
  String? warranty;
  String? warranty_type;
  String? warranty_month;
  String? refundable;
  String? refend_day;
  String? billing_mode_of_shipment;
  String? seo_product_title;
  String? seo_product_meta;
  String? targetted_keywords;
  String? maximum_shipping_cost;
  String? video_url;
  String? weight_in_grams;
  String? length_in_cm;
  String? breadth_in_cm;
  String? height_in_cm;
  String? delivery_charges_for_above_30kg_items;
  String? status_of_shipment;
  String? available_pin_code;

  AddProductModel(
      {this.product_id,
      this.categoryId,
      this.subCategoryId,
      this.childCategoryId,
      this.hsnNo,
      // this.isPopular,
      this.isTaxable,
      this.taxValue,
      this.sameSayDelivery,
      this.brandId,
      this.name,
      this.description,
      this.fullDescription,
      this.deliveryDay,
      this.images,
      this.default_image,
      this.variationsQuantity,
      this.specifactions,
      this.attribute_ids,
      this.cash_on_delivery,
      this.warranty,
      this.warranty_type,
      this.warranty_month,
      this.refundable,
      this.refend_day,
      this.billing_mode_of_shipment,
      this.seo_product_title,
      this.seo_product_meta,
      this.targetted_keywords,
      this.maximum_shipping_cost,
      this.video_url,
      this.weight_in_grams,
      this.length_in_cm,
      this.breadth_in_cm,
      this.height_in_cm,
      this.delivery_charges_for_above_30kg_items,
      this.status_of_shipment,
      this.available_pin_code});

  AddProductModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    childCategoryId = json['child_category_id'];
    hsnNo = json['hsn_no'];
    // isPopular = json['is_popular'];
    isTaxable = json['is_taxable'];
    taxValue = json['tax_value'];
    sameSayDelivery = json['same_say_delivery'];
    brandId = json['brand_id'];
    name = json['name'];
    description = json['description'];
    fullDescription = json['full_description'];
    deliveryDay = json['delivery_day'];
    images = json['images'];
    default_image = json['default_image'];
    if (json['variations_quantity'] != null) {
      variationsQuantity = <VariationsQuantity>[];
      json['variations_quantity'].forEach((v) {
        variationsQuantity!.add(new VariationsQuantity.fromJson(v));
      });
    }
    if (json['specifactions'] != null) {
      specifactions = <Specifactions>[];
      json['specifactions'].forEach((v) {
        specifactions!.add(new Specifactions.fromJson(v));
      });
    }

    cash_on_delivery = json['cash_on_delivery'].toString();
    warranty = json['warranty'].toString();
    warranty_month = json['warranty_month'].toString();
    warranty_type = json['warranty_type'].toString();
    refundable = json['refundable'].toString();
    refend_day = json['refend_day'].toString();
    billing_mode_of_shipment = json['billing_mode_of_shipment'].toString();
    seo_product_title = json['seo_product_title'].toString();
    seo_product_meta = json['seo_product_meta'].toString();
    targetted_keywords = json['targetted_keywords'].toString();
    maximum_shipping_cost = json['maximum_shipping_cost'].toString();
    video_url = json['video_url'].toString();
    weight_in_grams = json['weight_in_grams'].toString();
    length_in_cm = json['length_in_cm'].toString();
    breadth_in_cm = json['breadth_in_cm'].toString();
    height_in_cm = json['height_in_cm'].toString();
    delivery_charges_for_above_30kg_items =
        json['delivery_charges_for_above_30kg_items'].toString();
    status_of_shipment = json['status_of_shipment'].toString();
    available_pin_code = json['available_pin_code'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (product_id != null || product_id != "") {
      data['product_id'] = this.product_id;
    }
    data['category_id'] = this.categoryId;
    data['sub_category_id'] = this.subCategoryId;
    if (childCategoryId != null || childCategoryId != null) {
      data['child_category_id'] = this.childCategoryId;
    }
    data['hsn_no'] = this.hsnNo;
    //data['is_popular'] = this.isPopular;
    data['maximum_shipping_cost'] = maximum_shipping_cost;
    data['video_url'] = video_url;
    data['is_taxable'] = this.isTaxable;
    data['tax_value'] = this.taxValue;
    data['same_say_delivery'] = this.sameSayDelivery;
    data['brand_id'] = this.brandId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['full_description'] = this.fullDescription;
    data['delivery_day'] = this.deliveryDay;
    data['images'] = this.images;
    data['default_image'] = this.default_image;
    data['attribute_ids'] = this.attribute_ids;
    if (this.variationsQuantity != null) {
      data['variations_quantity'] =
          this.variationsQuantity!.map((v) => v.toJson()).toList();
    }
    if (this.specifactions != null) {
      data['specifactions'] =
          this.specifactions!.map((v) => v.toJson()).toList();
    }

    data['cash_on_delivery'] = cash_on_delivery;
    data['warranty'] = warranty;
    data['warranty_type'] = warranty_type;
    data['warranty_month'] = warranty_month;
    data['refundable'] = refundable;
    data['refend_day'] = refend_day;
    data['billing_mode_of_shipment'] = billing_mode_of_shipment;
    data['seo_product_title'] = seo_product_title;
    data['seo_product_meta'] = seo_product_meta;
    data['targetted_keywords'] = targetted_keywords;

    data['weight_in_grams'] = weight_in_grams;
    data['length_in_cm'] = length_in_cm;
    data['breadth_in_cm'] = breadth_in_cm;
    data['height_in_cm'] = height_in_cm;
    data['delivery_charges_for_above_30kg_items'] =
        delivery_charges_for_above_30kg_items;
    data['status_of_shipment'] = status_of_shipment;
    data['available_pin_code'] = available_pin_code;

    return data;
  }
}

class VariationsQuantity {
  int? variationId;
  String? basicPrice = "";
  String? offerPrice = "";
  String? quantity = "";
  String? attributeName = "";
  String? images = "";
  String? default_variation_image = "";
  bool? isEdit = false;

  List<AddAttribute>? attributes;

  VariationsQuantity(
      {this.variationId,
      this.basicPrice,
      this.offerPrice,
      this.quantity,
      this.attributes,
      this.images,
      this.default_variation_image});

  VariationsQuantity.fromJson(Map<String, dynamic> json) {
    variationId = json['variationId'];
    basicPrice = json['basic_price'];
    offerPrice = json['offer_price'];
    quantity = json['quantity'];
    if (json['attributes'] != null) {
      attributes = <AddAttribute>[];
      json['attributes'].forEach((v) {
        attributes!.add(new AddAttribute.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['variationId'] = this.variationId;
    data['basic_price'] = this.basicPrice;
    data['offer_price'] = this.offerPrice;
    data['quantity'] = this.quantity;
    data['images'] = this.images;
    data['default_variation_image'] = this.default_variation_image;
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddAttribute {
  String? attributeId = "";
  String? attributeValue = "";
  String? attributeName = "";
  String? unit_id = "";
  String? unit_name = "";

  AddAttribute({this.attributeId, this.attributeValue});

  AddAttribute.fromJson(Map<String, dynamic> json) {
    attributeId = json['attribute_id'];
    attributeValue = json['attribute_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attribute_id'] = this.attributeId;
    data['attribute_value'] = this.attributeValue;
    data['unit_id'] = this.unit_id;
    return data;
  }
}

class Specifactions {
  String? title;
  String? specifactionValue;
  int? forFilter;

  Specifactions({this.title, this.specifactionValue, this.forFilter});

  Specifactions.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    specifactionValue = json['specifaction_value'];
    forFilter = json['for_filter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['specifaction_value'] = this.specifactionValue;
    data['for_filter'] = this.forFilter;
    return data;
  }
}

class SpecifactionsCopy {
  String? title;
  String? specifactionValue;
  int? forFilter;

  SpecifactionsCopy({this.title, this.specifactionValue, this.forFilter});

  SpecifactionsCopy.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    specifactionValue = json['specifaction_value'];
    forFilter = json['for_filter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['specifaction_value'] = this.specifactionValue;
    data['for_filter'] = this.forFilter;
    return data;
  }
}

class VariationsQuantityCopy {
  int? variationId;
  String? basicPrice = "";
  String? offerPrice = "";
  String? quantity = "";
  String? attributeName = "";
  String? images = "";
  String? default_variation_image = "";
  bool? isEdit = false;

  List<AddAttribute>? attributes;

  VariationsQuantityCopy(
      {this.variationId,
      this.basicPrice,
      this.offerPrice,
      this.quantity,
      this.attributes,
      this.images,
      this.default_variation_image});

  VariationsQuantityCopy.fromJson(Map<String, dynamic> json) {
    variationId = json['variationId'];
    basicPrice = json['basic_price'];
    offerPrice = json['offer_price'];
    quantity = json['quantity'];
    if (json['attributes'] != null) {
      attributes = <AddAttribute>[];
      json['attributes'].forEach((v) {
        attributes!.add(new AddAttribute.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['variationId'] = this.variationId;
    data['basic_price'] = this.basicPrice;
    data['offer_price'] = this.offerPrice;
    data['quantity'] = this.quantity;
    data['images'] = this.images;
    data['default_variation_image'] = this.default_variation_image;
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
