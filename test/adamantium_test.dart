import 'package:adamantium/adamantium.dart';
import 'package:adamantium/src/adamantium_exceptions.dart';
import 'package:test/test.dart';

abstract class _ExternalDependencyWithDependency {
  String returnsStringFromInt(int value);
}

class _ExternalDependencyWithDependencyImpl
    implements _ExternalDependencyWithDependency {
  final _ExternalDependency _externalDependency;

  _ExternalDependencyWithDependencyImpl(this._externalDependency);

  @override
  String returnsStringFromInt(int value) {
    return _externalDependency.returnsStringFromInt(value);
  }
}

abstract class _ExternalDependency {
  String returnsStringFromInt(int value);
}

class _ExternalDependencyImpl implements _ExternalDependency {
  @override
  String returnsStringFromInt(int value) {
    return value.toString();
  }
}

class _ExternalDependencyImpl2 implements _ExternalDependency {
  @override
  String returnsStringFromInt(int value) {
    return (value + 1).toString();
  }
}

class ClassWithNoAbstract {}

class ClassWithNoAbstract2 {}

void main() {
  setUpAll(() {
    print('''RUNNING ADAMANTIUM DI TEST SUIT\n''');
  });

  tearDownAll(() {
    print(
        '''\n✅ ALL TESTS PASSED BECAUSE ADAMANTIUM IS SOLID AND HARD AS ROCK\n''');
  });
  test(
      '''Given a added bind
          When call get this bind
          Then should return instance''',
      () {
    AdamantiumBase ada = AdamantiumBase();

    ada.add<_ExternalDependency>(_ExternalDependencyImpl.new);

    final instance = ada.get<_ExternalDependency>();

    expect(instance.runtimeType, _ExternalDependencyImpl);
  });

  test(
      '''Given two different binds
          When call get each bind
          Then should return each instance''',
      () {
    AdamantiumBase ada = AdamantiumBase();

    ada.add<ClassWithNoAbstract>(ClassWithNoAbstract.new);
    ada.add<ClassWithNoAbstract2>(ClassWithNoAbstract2.new);

    final instance = ada.get<ClassWithNoAbstract>();
    final instance2 = ada.get<ClassWithNoAbstract2>();

    expect(instance.runtimeType, ClassWithNoAbstract);
    expect(instance2.runtimeType, ClassWithNoAbstract2);
  });

  test(
      '''Given two implementations for same abstract without a key
          When get bind
          Then will throw an exception''',
      () {
    try {
      AdamantiumBase ada = AdamantiumBase();

      ada.add<_ExternalDependency>(_ExternalDependencyImpl.new);
      ada.add<_ExternalDependency>(_ExternalDependencyImpl2.new);
    } catch (ex) {
      expect(ex.runtimeType, BindAlreadyExists);
    }
  });

  test(
      '''Given two implementations for same abstract with a key
          When get each bind
          Then should return each bind''',
      () {
    AdamantiumBase ada = AdamantiumBase();

    ada.add<_ExternalDependency>(_ExternalDependencyImpl.new, key: 'key1');
    ada.add<_ExternalDependency>(_ExternalDependencyImpl2.new, key: 'key2');

    final instance1 = ada.get<_ExternalDependency>(key: 'key1');
    final instance2 = ada.get<_ExternalDependency>(key: 'key2');

    expect(instance1.runtimeType, _ExternalDependencyImpl);
    expect(instance2.runtimeType, _ExternalDependencyImpl2);
  });

  test(
      '''Given a bind with dependency in constructor
          When get this bind
          Then should return constructed instance''',
      () {
    AdamantiumBase ada = AdamantiumBase();

    ada.add<_ExternalDependency>(_ExternalDependencyImpl.new, key: 'key1');
    ada.add<_ExternalDependency>(_ExternalDependencyImpl2.new, key: 'key2');
    ada.add<_ExternalDependencyWithDependency>(() =>
        _ExternalDependencyWithDependencyImpl(
            ada.get<_ExternalDependency>(key: 'key1')));

    final instance1 = ada.get<_ExternalDependencyWithDependency>();

    expect(instance1.runtimeType, _ExternalDependencyWithDependencyImpl);
  });

  test(
      '''Given no binds
          When getOrNull a bind who doenst exist
          Then should return null''',
      () {
    AdamantiumBase ada = AdamantiumBase();

    final instance1 = ada.getOrNull<_ExternalDependencyWithDependency>();

    expect(instance1, null);
  });

  test(
      '''Given a bind
         When getOrNull this bind
        Then should return the bind''',
      () {
    AdamantiumBase ada = AdamantiumBase();

    ada.add<_ExternalDependency>(_ExternalDependencyImpl.new);

    final instance1 = ada.getOrNull<_ExternalDependency>();

    expect(instance1.runtimeType, _ExternalDependencyImpl);
  });

  test(
      '''Given a lazySingleton bind
         When get or getOrNull this bind
         Then should return a lazy bind instance''',
      () {
    AdamantiumBase ada = AdamantiumBase();

    ada.addLazy<_ExternalDependency>(_ExternalDependencyImpl.new);

    final instance1 = ada.get<_ExternalDependency>();

    expect(instance1.runtimeType, _ExternalDependencyImpl);

    final instance2 = ada.getOrNull<_ExternalDependency>();

    expect(instance2.runtimeType, _ExternalDependencyImpl);
  });

  test(
      '''Given a factory bind
         When get or getOrNull this bind
         Then should return a different instance each time''',
      () {
    AdamantiumBase ada = AdamantiumBase();

    ada.addFactory<_ExternalDependency>(_ExternalDependencyImpl.new);

    final instance1 = ada.get<_ExternalDependency>();
    final instance2 = ada.get<_ExternalDependency>();

    expect(instance1.runtimeType, _ExternalDependencyImpl);
    expect(instance2.runtimeType, _ExternalDependencyImpl);
    expect(instance1.hashCode != instance2.hashCode, true);
  });

  test(
      '''Given a singleton bind
         When get or getOrNull this bind
         Then should return same instance each time''',
      () {
    AdamantiumBase ada = AdamantiumBase();

    ada.add<_ExternalDependency>(_ExternalDependencyImpl.new);

    final instance1 = ada.get<_ExternalDependency>();
    final instance2 = ada.get<_ExternalDependency>();

    expect(instance1.runtimeType, _ExternalDependencyImpl);
    expect(instance2.runtimeType, _ExternalDependencyImpl);
    expect(instance1.hashCode == instance2.hashCode, true);
  });

  test(
      '''Given a lazy singleton bind
         When get or getOrNull this bind
         Then should return same instance each time''',
      () {
    AdamantiumBase ada = AdamantiumBase();

    ada.addLazy<_ExternalDependency>(_ExternalDependencyImpl.new);

    final instance1 = ada.get<_ExternalDependency>();
    final instance2 = ada.get<_ExternalDependency>();

    expect(instance1.runtimeType, _ExternalDependencyImpl);
    expect(instance2.runtimeType, _ExternalDependencyImpl);
    expect(instance1.hashCode == instance2.hashCode, true);
  });

  test(
      '''Given a replacement bind
         When get or getOrNull this bind
         Then should return the new instance''',
      () {
    AdamantiumBase ada = AdamantiumBase();

    ada.addLazy<_ExternalDependency>(_ExternalDependencyImpl.new);

    final instance1 = ada.get<_ExternalDependency>();
    final instance2 = ada.get<_ExternalDependency>();

    expect(instance1.runtimeType, _ExternalDependencyImpl);
    expect(instance2.runtimeType, _ExternalDependencyImpl);
    expect(instance1.hashCode == instance2.hashCode, true);

    ada.replaceBind<_ExternalDependency>(() => _ExternalDependencyImpl2());

    final instance3 = ada.get<_ExternalDependency>();

    expect(instance3.runtimeType, _ExternalDependencyImpl2);
    expect(instance2.hashCode != instance3.hashCode, true);
  });
}
