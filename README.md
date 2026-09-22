# homebrew-claudmeter

Homebrew tap for [ClaudeMeter](https://github.com/andy-watanabe/claudmeter).

```bash
brew tap andy-watanabe/claudmeter
brew install claudemeter
```

## Releasing an update

The formula is pinned to a git tag in the main repo, not to `main`'s HEAD —
`brew upgrade` won't see new commits until this tap's formula is updated to
point at a new tag. After pushing changes to `andy-watanabe/claudmeter`:

```bash
# In the claudmeter repo:
git tag vX.Y.Z
git push origin vX.Y.Z

# Get the new tarball's checksum:
curl -fsSL -o /tmp/claudmeter.tar.gz \
  https://github.com/andy-watanabe/claudmeter/archive/refs/tags/vX.Y.Z.tar.gz
shasum -a 256 /tmp/claudmeter.tar.gz

# In this repo, update Formula/claudemeter.rb's `url` and `sha256` to match,
# then commit and push.
```

Test before pushing:

```bash
brew reinstall --build-from-source claudemeter
claudemeter --dump
```
