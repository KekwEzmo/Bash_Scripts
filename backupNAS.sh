#!binbash
MOUNT_POINT=/mntbackup_volume
BACKUP_DIR=$MOUNT_POINT/disk_backups

if [ ! -d $MOUNT_POINT ]; then
    echo Mount point $MOUNT_POINT does not exist or is not accessible.
    exit 1
fi
mkdir -p $BACKUP_DIR

BACKUP_FILE=disk_backup_$(date +%Y%m%d).img

dd if=/dev/sda1 of=$BACKUP_DIR/$BACKUP_FILE bs=4M

scp $BACKUP_DIR$BACKUP_FILE username@truenas_ip:/pathtodestination