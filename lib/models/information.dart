class ProductSale {
  final String product;
  final double totalSales;
  final double totalTaxes;

  ProductSale({
    required this.product,
    required this.totalSales,
    required this.totalTaxes,
  });

  factory ProductSale.fromJson(Map<String, dynamic> json) {
    return ProductSale(
      product: json['product'],
      totalSales: (json['totalSales'] as num).toDouble(),
      totalTaxes: (json['totalTaxes'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product,
      'totalSales': totalSales,
      'totalTaxes': totalTaxes,
    };
  }
}

class Sales {
  final String date;
  final List<ProductSale> productsSales;

  Sales({
    required this.date,
    required this.productsSales,
  });

  factory Sales.fromJson(Map<String, dynamic> json) {
    return Sales(
      date: json['date'],
      productsSales: (json['productsSales'] as List)
          .map((e) => ProductSale.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'productsSales': productsSales.map((e) => e.toJson()).toList(),
    };
  }
}

class Bill {
  final String id;
  final double price;
  final double taxes;
  final double total;

  Bill({
    required this.id,
    required this.price,
    required this.taxes,
    required this.total,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      price: (json['price'] as num).toDouble(),
      taxes: (json['taxes'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'taxes': taxes,
      'total': total,
    };
  }
}

class Bills {
  final String date;
  final List<Bill> billsInfo;

  Bills({
    required this.date,
    required this.billsInfo,
  });

  factory Bills.fromJson(Map<String, dynamic> json) {
    return Bills(
      date: json['date'],
      billsInfo: (json['billsInfo'] as List)
          .map((e) => Bill.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'billsInfo': billsInfo.map((e) => e.toJson()).toList(),
    };
  }
}

class Month {
  final String month;
  final double total;
  final double subtotal;
  final double iva;
  final List<Bill> billsWith;
  final List<Bill> billsWithout;

  Month({
    required this.month,
    required this.total,
    required this.subtotal,
    required this.iva,
    required this.billsWith,
    required this.billsWithout,
  });

  factory Month.fromJson(Map<String, dynamic> json) {
    return Month(
      month: json['month'],
      total: (json['total'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      iva: (json['iva'] as num).toDouble(),
      billsWith:
          (json['billsWith'] as List).map((e) => Bill.fromJson(e)).toList(),
      billsWithout:
          (json['billsWithout'] as List).map((e) => Bill.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'total': total,
      'subtotal': subtotal,
      'iva': iva,
      'billsWith': billsWith.map((e) => e.toJson()).toList(),
      'billsWithout': billsWithout.map((e) => e.toJson()).toList(),
    };
  }
}

class YearsInfo {
  final int year;
  final List<Month> months;

  YearsInfo({
    required this.year,
    required this.months,
  });

  factory YearsInfo.fromJson(Map<String, dynamic> json) {
    return YearsInfo(
      year: json['year'],
      months:
          (json['months'] as List).map((e) => Month.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'months': months.map((e) => e.toJson()).toList(),
    };
  }
}

class MonthTotal {
  final String month;
  final double total;

  MonthTotal({
    required this.month,
    required this.total,
  });

  factory MonthTotal.fromJson(Map<String, dynamic> json) {
    return MonthTotal(
      month: json['month'],
      total: (json['total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'total': total,
    };
  }
}

class ProductMonth {
  final String product;
  final double total;
  final List<MonthTotal> months;

  ProductMonth({
    required this.product,
    required this.total,
    required this.months,
  });

  factory ProductMonth.fromJson(Map<String, dynamic> json) {
    return ProductMonth(
      product: json['product'],
      total: (json['total'] as num).toDouble(),
      months: (json['months'] as List)
          .map((e) => MonthTotal.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product,
      'total': total,
      'months': months.map((e) => e.toJson()).toList(),
    };
  }
}

class YearProduct {
  final int year;
  final List<ProductMonth> products;

  YearProduct({
    required this.year,
    required this.products,
  });

  factory YearProduct.fromJson(Map<String, dynamic> json) {
    return YearProduct(
      year: json['year'],
      products: (json['products'] as List)
          .map((e) => ProductMonth.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'products': products.map((e) => e.toJson()).toList(),
    };
  }
}
