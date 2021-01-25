Simple Crypt
=======
[![Gem Version](https://badge.fury.io/rb/simple_crypt.svg)](https://badge.fury.io/rb/simple_crypt)

A light-weight gem for encrypting and decrypting strings. Simple Crypt uses the latest AES and KDF encryption standards to ensure the confidentiality, integrity, and authenticity of data sent through the service.

## Getting Started

Simple Crypt requires openssl version 1.1.0 or greater to support the mode of encryption used by the service. For instructions on installation of the latest version, plese refer to OpenSSL's [readme](https://github.com/openssl/openssl/blob/master/INSTALL), or check your OS'es package manager.
Secrets is also intended to run with Docker, so please refer to their [readme](https://docs.docker.com/install/) for installation and setup.


## Installation

Once the dependencies have been set up, simply run the below commands:

```
gem install simple_crypt
```

## Use

To use, create a new class:
```
crypt = SimpleCrypt.new
```
Then, call the encrypt or decrypt method:
```
sec = crypt.encrypt('hidden text', 'password')
 => #<Secret:>
crypt.decrypt(sec, 'password')
 => 'hidden text'
 ```

## Security Features

Ephemeral Secrets uses three main security standards to ensure full information security.

### AES

The first of which is the encryption/decryption mode. Secrets uses `AES-256-GCM`. This uses the AES standard with a key size of 256 bits and the GCM mode. GCM is a combination of Galois field authentication and a counter mode algorithm and can be further documented [here](https://en.wikipedia.org/wiki/Galois/Counter_Mode).
GCM was designed to be performant (via parallelized operations) and to guarantee authenticity and confidentiality. By using an AEAD (authenticated encryption with associated data) cipher mode, one can guarantee that the ciphertext maintains integrity upon decryption and will fail to decrypt if someone attempts to modify the ciphertext while it remains encrypted.

### Scrypt

Scrpyt is a password-based key derivation function and us used to generate the AES key used for encryption and decryption. Scrypt was designed to take input paramaters that relate largely to the hardware resources available. Because it uses the most resources available to it, brute force or custom hardware attacks become infeasible. More on the function can be read [here](https://en.wikipedia.org/wiki/Scrypt).

### Random Strings

SecureRandom is used to generate both random IDs for the secrets to be stored as well as random passwords. SecureRandom supports random number generation from OpenSSL and the `/dev/urandom` entropy pool device. More on that can be found [here](https://ruby-doc.org/stdlib-2.5.1/libdoc/securerandom/rdoc/SecureRandom.html)
## Licensing

This project is licensed under the terms of the GNU General Public License v3.0.
