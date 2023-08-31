import 'package:adamantium/src/adamantium_bind.dart';
import 'package:adamantium/src/adamantium_exceptions.dart';

abstract class AdamantiumBase {
  final String _name;

  // ignore: unused_element
  AdamantiumBase._(this._name);

  String get name => _name;

  /// Get a Bind of type [T] with a optional `key`
  T get<T>({String? key});

  /// Get a Bind of type [T] with a optional `key`
  ///
  /// Returns `null` if not exists
  T? getOrNull<T>({String? key});

  /// Adds a new singleton dependency based in `constructor` with [T] type, [T] is mandatory
  ///
  /// It can be used .new when there is no dependencies to construct object
  ///
  /// It HAS to use contructor when it has dependencies to correct binding
  void add<T>(Function constructor, {String? key});

  /// Adds a new lazy singleton dependency based in `constructor` with [T] type, [T] is mandatory
  ///
  /// It can be used .new when there is no dependencies to construct object
  ///
  /// It HAS to use contructor when it has dependencies to correct binding
  void addLazy<T>(Function constructor, {String? key});

  /// Adds a new factory dependency based in `constructor` with [T] type, [T] is mandatory
  ///
  /// It can be used .new when there is no dependencies to construct object
  ///
  /// It HAS to use contructor when it has dependencies to correct binding
  void addFactory<T>(Function constructor, {String? key});

  /// Adds a new singleton dependency based in `constructor` with [T] type, [T] is mandatory
  ///
  /// It can be used .new when there is no dependencies to construct object
  ///
  /// It HAS to use contructor when it has dependencies to correct binding
  ///
  /// Will replace other bind if actually the bind exists
  void addReplaceIfExists<T>(Function constructor, {String? key});

  /// Given type [T]
  ///
  /// Replaces a bind with `newInstance`
  ///
  /// throws a [BindNotFound] if not found
  void replaceBind<T>(Function newConstructor);

  /// Remove all binds
  void removeAll();

  factory AdamantiumBase({String name = 'adamantium'}) {
    return _Adamantium(name);
  }
}

class _Adamantium implements AdamantiumBase {
  final Map<String, AdamantiumBind> _binds = {};

  @override
  final String _name;

  _Adamantium(this._name);

  @override
  void addReplaceIfExists<T>(Function constructor, {String? key}) {
    key ??= '';
    final String uniqueCode = T.toString() + key;

    _binds[uniqueCode] = (AdamantiumBind<T>(
        constructor: constructor,
        instance: null,
        bindType: BindType.lazySingleton.type));
  }

  @override
  void add<T>(Function constructor, {String? key}) {
    key ??= '';
    final String uniqueCode = T.toString() + key;

    if (_binds[uniqueCode] != null) {
      throw BindAlreadyExists(
          '''
        bind already exists ${T.toString()}\n
        if binding a second implementation for a abstract provided in T in add<T>
        then a key should be given
          ''');
    }

    _binds[uniqueCode] =
        (AdamantiumBind<T>(constructor: constructor, instance: constructor()));
  }

  @override
  void addLazy<T>(Function constructor, {String? key}) {
    key ??= '';
    final String uniqueCode = T.toString() + key;

    if (_binds[uniqueCode] != null) {
      throw BindAlreadyExists(
          '''
        bind already exists ${T.runtimeType}\n
        if binding a second implementation for a abstract provided in T in add<T>
        then a key should be given
          ''');
    }

    _binds[uniqueCode] = (AdamantiumBind<T>(
        constructor: constructor,
        instance: null,
        bindType: BindType.lazySingleton.type));
  }

  @override
  T? getOrNull<T>({String? key}) {
    final bind = _getBind<T>(key);
    final instance = bind?.instance;

    return instance;
  }

  @override
  T get<T>({String? key}) {
    final bind = _getBind<T>(key);

    final instance = bind?.instance;

    if (instance == null) {
      throw BindNotFound('${T.runtimeType} not found');
    }

    return instance;
  }

  @override
  void addFactory<T>(Function constructor, {String? key}) {
    key ??= '';
    final String uniqueCode = T.toString() + key;

    if (_binds[uniqueCode] != null) {
      throw BindAlreadyExists(
          '''
        bind already exists ${T.runtimeType}\n
        if binding a second implementation for a abstract provided in T in add<T>
        then a key should be given
          ''');
    }

    _binds[uniqueCode] = (AdamantiumBind<T>(
        constructor: constructor,
        instance: null,
        bindType: BindType.factory.type));
  }

  AdamantiumBind? _getBind<T>(String? key) {
    key ??= '';
    final String uniqueCode = T.toString() + key;

    final bind = _binds[uniqueCode];

    if (bind != null &&
        bind.instance == null &&
        bind.bindType == BindType.lazySingleton.type) {
      _binds[uniqueCode] = AdamantiumBind(
          constructor: bind.contructor,
          instance: bind.contructor(),
          bindType: bind.bindType);
    } else if (bind != null && bind.bindType == BindType.factory.type) {
      _binds[uniqueCode] = AdamantiumBind(
          constructor: bind.contructor,
          instance: bind.contructor(),
          bindType: bind.bindType);
    }

    return _binds[uniqueCode];
  }

  @override
  String get name => _name;

  @override
  void removeAll() {
    _binds.clear();
  }

  @override
  void replaceBind<T>(newConstructor, {String? key}) {
    key ??= '';

    final bind = _binds[T.toString() + key];

    if (bind == null) {
      throw BindNotFound('''bind ${T.runtimeType} not found''');
    }

    BindType bindType =
        BindType.values.where((element) => element.name == bind.bindType).first;

    switch (bindType) {
      case BindType.lazySingleton:
        _binds[T.toString() + key] = AdamantiumBind<T>(
            constructor: newConstructor,
            instance: null,
            bindType: bindType.type);
        break;
      case BindType.factory:
        _binds[T.toString() + key] = AdamantiumBind<T>(
            constructor: newConstructor,
            instance: null,
            bindType: bindType.type);
        break;
      case BindType.singleton:
      default:
        _binds[T.toString() + key] = AdamantiumBind<T>(
            constructor: newConstructor,
            instance: newConstructor(),
            bindType: bindType.type);
    }
  }
}
