enum CountryCodeEnum {
  southKorea('+82'),
  usa("+1"),
  philippines("+63"),
  israel('+972');

  const CountryCodeEnum(this.type);

  final String type;
}

// Using an extension
// Enhanced enums

extension ConvertMessage on String {
  CountryCodeEnum toEnum() {
    switch (this) {
      case '+82':
        return CountryCodeEnum.southKorea;
      case '+972':
        return CountryCodeEnum.israel;
      case '+1':
        return CountryCodeEnum.usa;
      case '+63':
        return CountryCodeEnum.philippines;
      default:
        return CountryCodeEnum.southKorea;
    }
  }
}


Map<String, String> countries = {'+82': '한국',  '+972':'이스라엘', '+1': '미국', '+63': '필리핀'};