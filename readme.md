# Iosevka Lyte

My personal favorite font which is simply a customized [Iosevka][iosevka] build.

This produces TrueType (TTF) and Web Open Font Format 2.0 (WOFF2) fonts as well
as a minified version of the font with support for a tiny fraction of ASCII
characters for use on the web.

## Why here?

I moved the font into its own flake to build separately from [my main Nix
repo][lytedev-nix] in order to enable NixOS updates to be faster. Building
the font takes a long time even on a large machine and I generally don't need
updates to the font with same same urgency that I need updates to the rest of
the software I use.

This lets me decouple my font updates from my OS updates.

Novel, right? 🙄

# Build

```
nix build
```

# Release

Releases happen automatically and are published to our [free Cachix instance][iosevka-lyte-cachix]. See below for usage.

# Usage

## 1. Add this Flake to your inputs

```nix
inputs.iosevka-lyte.url = "github:lytedev/iosevka-lyte";
```

## 2. Add cache entries to your flake

```nix
{
  nixConfig = {
    extra-substituters = ["https://iosevka-lyte.cachix.org"];
    extra-trusted-public-keys = ["iosevka-lyte.cachix.org-1:5pX+LwVdlfWJtmubPErASJecnm1q3a/RoZmah1GU+FM="];
  };
}
```

## 3. Install and configure the font as needed

Here are some examples:

```nix
# in a nixos module
fonts.packages = [inputs.iosevka-lyte.packages.${system}.default];

# in a home-manager module
gtk.font = pkgs.iosevkaLyteTerm;

# by referencing its name and having it installed
programs.ghostty.settings.font-family = "IosevkaLyteTerm"
```

## 4. Update and accept the new cache entries

```bash
$ nixos-rebuild switch --flake "$YOUR_FLAKE" --accept-flake-config
```

[lytedev-nix]: https://git.lyte.dev/lytedev/nix
[iosevka]: https://github.com/be5invis/Iosevka
[iosevka-lyte-cachix]: https://app.cachix.org/cache/iosevka-lyte#pull
