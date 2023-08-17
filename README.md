# DumbKey - Cross-Platform Password and Information Manager

DumbKey is a powerful and secure cross-platform application designed to
help you manage your sensitive information, including passwords,
credit/debit information, and notes. With local encryption and seamless
synchronization capabilities, your data remains safe and accessible
across all your devices. This repository contains the source code.

# Features

Secure Data Storage: Your passwords, credit/debit information, and notes are stored securely using a robust local encryption mechanism before being stored in Firebase, ensuring your data's confidentiality.

Cross-Platform Accessibility: SecurePass is designed to work on multiple platforms, including Windows, macOS, Linux, iOS, and Android, allowing you to access your information whenever and wherever you need it.

Seamless Synchronization: With SecurePass, your data is automatically synchronized across all your devices, providing a seamless and up-to-date experience across platforms.

Account Management System: SecurePass features an intuitive account management system that enables users to easily sign up, create accounts, and manage their profiles.

# Security

Security is our top priority. Dumkey uses the popular and well tested
cryptography library [LibSodium](https://doc.libsodium.org/) employs the
XChaCha20-Poly1305-IETF cipher for encryption and decryption.

The app is designed to be local first, all data is available offline,
While the cloud uses Firebase for syncing, All data is undergoes
local encryption, ensuring that only you can access your decrypted data.

# Installation
Clone this repository to your local machine.

```bash
git clone https://github.com/RA341/DumbKey
```
Navigate to the repository directory.

```bash
cd dumbkey
```
Install Flutter CLI using the following official installation guide:
[Flutter Installation Guide](https://flutter.dev/docs/get-started/install)

Use the following commands to build for your OS

```bash
flutter build windows
flutter build macos
flutter build linux
flutter build ios
flutter build android
```


