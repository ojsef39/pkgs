# Deploy configuration
deploy:
    nh os switch --hostname josef-test-vm .

# Update packages
update:
    nix flake update