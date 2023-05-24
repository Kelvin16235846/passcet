class CardFace{
  String wz="";
  String text="";

}
class WzCard {
  String _wz;
  String _front;
  String _front_top;
  String _front_middle;
  String _front_bottom;

  String _back;
  String _back_top;
  String _back_middle;
  String _back_bottom;
  int _index;

  // 新增的成员变量
  String _cardType;

  // 添加构造函数
  WzCard({
    String wz = '',
    String front = '',
    String front_top = '',
    String front_middle = '',
    String front_bottom = '',
    String back = '',
    String back_top = '',
    String back_middle = '',
    String back_bottom = '',
    int index = -1,
    String cardType = '卡片类型', // 设置_cardType的默认值
  })  : _wz = wz,
        _front = front,
        _front_top = front_top,
        _front_middle = front_middle,
        _front_bottom = front_bottom,
        _back = back,
        _back_top = back_top,
        _back_middle = back_middle,
        _back_bottom = back_bottom,
        _index = index,
        _cardType = cardType; // 初始化_cardType

  // 为每个域设置 getter
  String get wz => _wz;
  String get front => _front;
  String get front_top => _front_top;
  String get front_middle => _front_middle;
  String get front_bottom => _front_bottom;
  String get back => _back;
  String get back_top => _back_top;
  String get back_middle => _back_middle;
  String get back_bottom => _back_bottom;
  int get index => _index;

  // 新增的getter
  String get cardType => _cardType;

  // 为每个域设置 setter
  set wz(String value) {
    _wz = value;
  }

  set front(String value) {
    _front = value;
  }

  set front_top(String value) {
    _front_top = value;
  }

  set front_middle(String value) {
    _front_middle = value;
  }

  set front_bottom(String value) {
    _front_bottom = value;
  }

  set back(String value) {
    _back = value;
  }

  set back_top(String value) {
    _back_top = value;
  }

  set back_middle(String value) {
    _back_middle = value;
  }

  set back_bottom(String value) {
    _back_bottom = value;
  }

  set index(int value) {
    _index = value;
  }

  // 新增的setter
  set cardType(String value) {
    _cardType = value;
  }
}