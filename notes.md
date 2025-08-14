# How to

## Make i915-sriov-dkms-pkg

```bash
make kernel i915-sriov-dkms-pkg REGISTRY=ghcr.io/ojsef39 PLATFORM=linux/amd64 PUSH=true
BUILDKIT_PROGRESS=plain make kernel i915-sriov-dkms-pkg REGISTRY=ghcr.io/ojsef39 PLATFORM=linux/amd64 PUSH=true 2>&1 | tee build.log
```

then `cd ../extensions/` and `build-and-deploy-extension.sh`
