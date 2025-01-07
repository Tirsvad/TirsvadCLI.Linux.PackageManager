[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

<br />
<div align="center">
    <a href="https://github.com/TirsvadCLI/Linux.Distribution">
        <img src="logo/logo.png" alt="Logo" width="80" height="80">
    </a>
</div>

# TirsvadCLI Linux Package manager

The TirsvadCLI Linux Package Manager is a script designed to manage software packages on Linux systems. This script supports local installations of packages and offers functions to update and upgrade your system efficiently.

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
  - [Clone the Repository](#clone-the-repository)
- [Usage](#usage)
- [Testing](#testing)
- [License](#license)
- [Contributors](#contributors)

## Features

- Install Packages: Installs specified packages locally on a  server.
- System Update: Updates the package list based on the Linux distribution.
- System Upgrade: Upgrades installed packages on the system.

## Requirements

To use the package manager, ensure that you have bash installed on your Linux system.

## Getting Started

### Clone the Repository

```bash
git clone git@github.com:TirsvadCLI/Linux.PackageManager.git
```

## Usage

### Functions

- `tcli_linux_packagemanager_install()`: Installs packages locally on a server.
  - **Parameters:** A list of packages to install.
  - **Returns:**
    - `0`: If the installation was successful.
    - `1`: If the installation failed.
  - **Example:**
    ```bash
    tcli_linux_packagemanager_install package1 package2
    ```
- `tcli_linux_packagemanager_system_update()`: Updates the package list on the system.
  - **Example:**
    ```bash
    tcli_linux_packagemanager_system_update
    ```
- `tcli_linux_packagemanager_system_upgrade()`: Updates the package list on the system.
  - **Example:**
    ```bash
    tcli_linux_packagemanager_system_upgrade
    ```

## Testing

```bash
docker-compose build
docker run --rm -it  tirsvadclilinuxpackagemanager_debian_service:latest
```

In the docker container

```bash
/usr/src/app/Test# bash test_PackageManager.sh
```

## License

This project is licensed under the GNU GPL 3 License. See the [LICENSE](LICENSE) file for more details.

## Contributors

See the [CONTRIBUTING.md](CONTRIBUTING.md) file for information on how to contribute to this project.

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[contributors-shield]: https://img.shields.io/github/contributors/TirsvadCLI/Linux.PackageManager?style=for-the-badge
[contributors-url]: https://github.com/TirsvadCLI/Linux.PackageManager/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/TirsvadCLI/Linux.PackageManager?style=for-the-badge
[forks-url]: https://github.com/TirsvadCLI/Linux.PackageManager/network/members
[stars-shield]: https://img.shields.io/github/stars/TirsvadCLI/Linux.PackageManager?style=for-the-badge
[stars-url]: https://github.com/TirsvadCLI/Linux.PackageManager/stargazers
[issues-shield]: https://img.shields.io/github/issues/TirsvadCLI/Linux.PackageManager?style=for-the-badge
[issues-url]: https://github.com/TirsvadCLI/Linux.PackageManager/issues
[license-shield]: https://img.shields.io/github/license/TirsvadCLI/Linux.PackageManager?style=for-the-badge
[license-url]: https://github.com/TirsvadCLI/Linux.PackageManager/blob/master/LICENSE
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/jens-tirsvad-nielsen-13b795b9/
