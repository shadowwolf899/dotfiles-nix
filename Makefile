hm-build:
	nix run . -- build --flake .

hm-switch:
	nix run . -- switch --flake .

build:
	nixos-rebuild build --flake .

switch:
	sudo nixos-rebuild switch --flake .

test:
	nix flake check

update:
	nix flake update
