                _                             _   _                 
               | |                           | | (_)                
      __ _  __| | __ _ _ __ ___   __ _ _ __ | |_ _ _   _ _ __ ___  
      / _` |/ _` |/ _` | '_ ` _ \ / _` | '_ \| __| | | | | '_ ` _ \ 
     | (_| | (_| | (_| | | | | | | (_| | | | | |_| | |_| | | | | | |
      \__,_|\__,_|\__,_|_| |_| |_|\__,_|_| |_|\__|_|\__,_|_| |_| |_|

***<p style="text-align: center;">A rigid and performatic dependecy injector.</p>***

## Features

- Singleton, lazy singleton and factory injection
- Dependencies can be replaced (mainly for testing)
- Rigid type binding
- Simple API
- Safe (Exceptions are throwed when devs made mistakes)

## Why?

You can be asking why in some choices for *adamantium*.

- Dependencies are registered in a Map using their own runtime type name (faster to retrieve and add)
- Type binding using runtime type name isn't sweet for syntax, but it is safe, rigid and simple (no code generation or reflection)
- Simple and no magical API (More predictable)

## Get started

To get started with simple Adamantium API just create a instance:

    AdamantiumBase ada = AdamantiumBase();

### Singleton

A singleton dependency mean that when this dependency is injected it is constructed instantly and everytime you get, it's always the same instance.

    AdamantiumBase ada = AdamantiumBase();
    ada.add<_ExternalDependency>(_ExternalDependencyImpl.new);

### Lazy Singleton

A lazy singleton dependency mean that when this dependency is injected it isn't constructed instantly and when you retrieve it will construct, everytime you get, it's always the same instance.

    AdamantiumBase ada = AdamantiumBase();
    ada.addLazy<_ExternalDependency>(_ExternalDependencyImpl.new);

### Factory

A factory dependency mean that when this dependency is injected it isn't constructed instantly and when you retrieve it will construct, everytime you get, it's always a new instance.

    AdamantiumBase ada = AdamantiumBase();
    ada.addFactory<_ExternalDependency>(_ExternalDependencyImpl.new);

### Retrieve a dependency

It is simple as calling a method with binding type to retrieve a dependency.

    AdamantiumBase ada = AdamantiumBase();
    ada.add<_ExternalDependency>(_ExternalDependencyImpl.new);
    final instance = ada.get<_ExternalDependency>();
    print(instance); // Output: Instance of '_ExternalDependencyImpl'

### Add a dependency with a key

When you have to bind two different dependencies with same *T* type (e.g. two different implementations of same abstract class), it can be made using a *key* attribute

    AdamantiumBase ada = AdamantiumBase();
    ada.add<_ExternalDependency>(_ExternalDependencyImpl.new, key: 'one');
    ada.add<_ExternalDependency>(_ExternalDependencyImpl2.new, key: 'two');
    final instance = ada.get<_ExternalDependency>(key: 'one');
    final instance2 = ada.get<_ExternalDependency>(key: 'two');
    print(instance); // Output: Instance of '_ExternalDependencyImpl'
    print(instance2); // Output: Instance of '_ExternalDependencyImpl2'

## TODO

- Module approach (group dependencies)
- Example
