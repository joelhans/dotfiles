#!/bin/sh
# Fix USB3 suspend and hibernate problems
# Found at: https://bugs.launchpad.net/ubuntu/+source/pm-utils/+bug/562484/comments/3
#   https://forums.fedoraforum.org/showthread.php?249335-Can-t-suspend-or-hibernate
#   https://forum.artixlinux.org/index.php/topic,1591.15.html
#   https://bbs.archlinux.org/viewtopic.php?id=217775
#   https://forums.fedoraforum.org/showthread.php?299457-How-to-start-script-from-etc-pm-sleep-d-after-resume-from-hibernate
# Install at /var/usr/lib/systemd/system-sleep/local.sh
#   sudo cp $HOME/src/dotfiles/bin/01fix_usb3.sh /var/usr/lib/systemd/system-sleep/local.sh
#   sudo chown root:root /var/usr/lib/systemd/system-sleep/local.sh
#   sudo chmod +x /var/usr/lib/systemd/system-sleep/local.sh 

case $1 in
  hibernate)
    echo "01fix-usb3: Hibernating... removing xhci_hcd module." | systemd-cat
    modprobe -r xhci_hcd
    ;;

  suspend)
    echo "01fix-usb3: Suspending... removing xhci_hcd module." | systemd-cat
    modprobe -r xhci_hcd
    ;;

  post)
    echo "01fix-usb3: Resuming... adding xhci_hcd module." | systemd-cat
    modprobe xhci_hcd
    ;;

  *)
    echo "01fix-usb3: wrong argument!" | systemd-cat
    ;;
esac
