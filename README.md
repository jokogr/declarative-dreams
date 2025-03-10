# Declarative dreams

A Git repository to help a friend set up NixOS on his laptop.

## Requirements

I have received the following requirements:

- X230 (to-do)
- No DM required
- btrfs
- luks partitioning
- suspend-then-hybernate
- wake-up from swap file
- Packages
  - i3blocks (to-do)
  - sway
  - terminator
  - zsh
  - dunst
  - wmenu
  - wofi
  - swayidle
  - grimshot
  - wtype
  - brightnessctl
  - mate-polkit (to-do)
  - geoclue
  - gammastep
  - Firefox
  - code
  - remmina
  - clipman
  - podman

## High Level Principles

- Start from a VM and progress into the physical machine
- Do things progressively and with separate commits

## VM instructions

### Setup

1. (Hypervisor) Download installer image:

    ```
    curl -LO https://github.com/nix-community/nixos-images/releases/download/nixos-24.11/nixos-installer-x86_64-linux.iso`
    ```

1. (Hypervisor) Create VM:

    ```
    virt-install \
      --name declarative-dreams \
      --vcpus 4 \
      --memory 10240 \
      --disk=size=20,serial=my-disk \
      --cdrom=./nixos-installer-x86_64-linux.iso \
      --osinfo nixos-unknown \
      --network bridge=virbr0 \
      --boot uefi
    ```

1. Once the installer boots, record the IP address and the root credentials and use them to login, e.g.:

    ```
    ssh -o "UserKnownHostsFile=/dev/null" root@192.168.122.111
    ```

1. Download and extract the repository files:

    ```
    curl -LO https://github.com/jokogr/declarative-dreams/archive/refs/heads/main.tar.gz
    tar xvzf main.tar.gz
    ```

1. Update the public key, e.g.:

   ```
   vi declarative-dreams-main/id_rsa.pub
   ```

1. Write the LUKS password to `/tmp/secret.key`, e.g.:

   ```
   echo trololo > /tmp/secret.key
   ```

1. Run nixos-facter:

    ```
    nix run --option experimental-features "nix-command flakes" nixpkgs#nixos-facter -- -o declarative-dreams-main/facter.json
    ```

1. Persist the report in the repository for future usage (to-do)

1. Run disko-main:

   ```
   sudo nix run 'github:nix-community/disko/latest#disko-install' -- --flake declarative-dreams-main#vm --disk main /dev/disk/by-id/virtio-my-disk
   ```

1. Reboot and login as root in the new installation.

### Clean up

```
virsh reset declarative-dreams
virsh undefine --nvram declarative-dreams
rm ~/.local/share/images/declarative-dreams.qcow2
```
