class CurrencyFormatter {
  static String formatToRupiah(int price) {
    final priceString = price.toString();
    final result = StringBuffer('Rp ');
    
    for (int i = 0; i < priceString.length; i++) {
      if ((priceString.length - i) % 3 == 0 && i != 0) {
        result.write('.');
      }
      result.write(priceString[i]);
    }
    
    return result.toString();
  }
} 