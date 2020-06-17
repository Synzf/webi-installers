# title: macOS
# homepage: https://bootableinstaller.com/macos/
# tagline: |
#   Creates a bootable macOS installer ISO in ~/Downloads.
# description: |
#   Downloads the official OS X / macOS dmg from Apple to create bootable installers - works from macOS, Linux, or even Windows (through VirtualBox).
# examples: |
#
#   Use with Balena Etcher to burn ISO to USB, or boot with VirtualBox.
#
#   ```txt
#   Created ~/Downloads/el-capitan.iso
#   ```

set -e
set -u

webi_download

pushd ~/Downloads 2>&1 >/dev/null

if [ "Darwin" == "$(uname -s)" ]; then
  curl -fsSL 'https://gist.githubusercontent.com/solderjs/8c36d132250163011c83bad8284975ee/raw/5a291955813743c20c12ca2d35c7b1bb34f8aecc/create-bootable-installer-for-os-x-el-capitan.sh' -o create-bootable-installer-for-os-x-el-capitan.sh
  bash create-bootable-installer-for-os-x-el-capitan.sh
else
  curl -fsSL 'https://gist.githubusercontent.com/solderjs/9834a45a6c21a41e8882698a00b55787/raw/c43061cd0c53ec675996f5cb66c7077e666aabd4/install-mac-tools.sh' -o install-mac-tools.sh
  # TODO add xar to webinstall.dev
  sudo apt install libz-dev # needed for xar
  bash install-mac-tools.sh
  echo "WARN: may need a restart for hfsplus to be recognized by the kernel"

  curl -fsSL 'https://gist.github.com/solderjs/04fd06560a8465a695337eb502f5b0e9/raw/0a06fb4dce91399d374d9a12958dabb48a9bd42a/empty.7400m.img.bz2' -o empty.7400m.img.bz2

  curl -fsSL 'https://gist.githubusercontent.com/solderjs/9834a45a6c21a41e8882698a00b55787/raw/c43061cd0c53ec675996f5cb66c7077e666aabd4/linux-create-bootable-macos-recovery-image.sh' -o linux-create-bootable-macos-recovery-image.sh
  bash linux-create-bootable-macos-recovery-image.sh
fi

echo ""
echo "Created $HOME/Downloads/el-capitan.iso"
echo ""

popd 2>&1 >/dev/null
