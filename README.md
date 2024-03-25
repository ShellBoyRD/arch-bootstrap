# arch-bootstrap
## A simple script to setup an arch chroot environment from which to run archinstall

Step 1: copy and paste this codeblock
```bash
git clone github.com/ShellBoyRD/arch-bootstrap/
cd arch-bootstrap
chmod +x arch-bootstrap.bash
sudo ./arch-bootstrap.bash
arch-chroot $ARCH_CHROOT_DIR/root.x86_64
```
That should have you chrooted into the arch environment when you're done, then just run this command.
```bash
archinstall
```
If that doesn't work try the last command from the first block again first like so.
```bash
arch-chroot $ARCH_CHROOT_DIR/root.x86_64
```
Then try running the archinstall command again.