/// A class for defining a AdamantiumBind
///
/// Demands a `constructor` who can be a `new` when there is no args or can be a public constructor with args
///
/// `instance` keeps a instance returned by constructor
///
/// `bindType` (default value: 'singleton') provides what bind type it is, it can be `singleton`, `lazySingleton` or `factory` check docs for more details
///
/// `bindType` is referencing a [String] on purpose to keep Adamantium decoupled from his own dependencies
///
/// It is possible to use [BindType] to reference `bindType` aswell (example: BindType.singleton.type)
abstract class AdamantiumBind<T> {
  final Function contructor;
  final T? instance;
  final String bindType;

  // ignore: unused_element
  AdamantiumBind._(this.contructor, this.instance, this.bindType);

  factory AdamantiumBind(
      {required Function constructor,
      required T? instance,
      String bindType = 'singleton'}) {
    return _AdamantiumBind<T>(constructor, instance, bindType);
  }
}

class _AdamantiumBind<T> implements AdamantiumBind<T> {
  @override
  final Function contructor;
  @override
  final T? instance;
  @override
  final String bindType;

  _AdamantiumBind(this.contructor, this.instance, this.bindType);
}

enum BindType {
  /// Always the same instance, constructed when binded
  singleton('singleton'),

  /// Always the same instance, constructed when get the bind
  lazySingleton('lazySingleton'),

  /// Always a different instance when getting the bind
  factory('factory');

  final String _type;

  String get type => _type;

  const BindType(this._type);
}
