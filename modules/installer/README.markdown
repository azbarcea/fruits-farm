#installer

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with the java module](#setup)
    * [Beginning with the java module](#beginning-with-the-java-module)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)

##Overview

Installs ... something

##Module Description

Blah Blah

##Setup

###Beginning with the installer module

Blah Blah

##Usage

Blah Blah

```
class { 'installer':
  distribution => 'jre',
}
class { 'installer:migrate':
  distribution => 'something',
}
class { 'installer:fallback':
  distribution => 'something',
}
```

##Reference

###Classes

####Public classes

* `installer:migrate`: This is the module's main class, which installs and manages ...
* `installer:fallback`: This is the module's main class, which installs and manages ...

####Private classes

* `blah`: Probably will be some

###Parameters:

The following parameters are available:

* `distribution`:

* `version`: 

* `package`:

###Facts

The java module includes a few facts to describe the Something:

