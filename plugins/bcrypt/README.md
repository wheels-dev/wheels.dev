# cfwheels-bcrypt

[![Build Status](https://travis-ci.org/neokoenig/cfwheels-bcrypt.svg?branch=master)](https://travis-ci.org/neokoenig/cfwheels-bcrypt)

CFWheels 2.x plugin helper methods for the bCrypt Java Lib

Note, this plugin requires CFWheels 2.x due to the automatic java mapping

## Usage

### Encrypt a password

```
password = "CatzAreBetterThanDogz";

// Hash a password for the first time
hashedPassword   = bCryptHashPW(password, bCryptGenSalt());

// With different complexity:
// gensalt's log_rounds parameter determines the complexity
// the work factor is 2**log_rounds, and the default is 10
hashedPassword   = bCryptHashPW(password, bCryptGenSalt(12));
```

### Compared hashed password

```
// Check that an unencrypted password matches one that has
// previously been hashed
result = bCryptCheckPW(candidate,hashed);
```
