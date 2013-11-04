#!/bin/sh

backupfile_prefix=/tmp/backup_

targets=`cat $HOME/.backups/directories | sed /^#/d`

exclusion_args=`cat $HOME/.backups/exclusions | sed -e /^#/d -e '/^$/d' -e 's/^/-not -path "/' -e 's/$/"/'`

file_list_file=/tmp/file_list

for target in $targets ; do
    echo "Finding files in $target"
    rm -f $file_list_file
    eval /usr/bin/find $target -type f $exclusion_args > $file_list_file
    for subtarget in $targets/* ; do
	if [ -d "$subtarget" ] ; then
	    echo "Packaging files in $subtarget"
	    backupfile="$backupfile_prefix`echo $subtarget | tr / _`.tar"

	    # Figure out which files are _not_ going in this archive.
	    grep -v ^$subtarget $file_list_file > $file_list_file.pass

	    # Make the archive.
	    cd $subtarget
	    grep ^$subtarget $file_list_file | sed -e "s|^$subtarget/|\"|" -e 's/$/"/' | xargs -n 1000 tar rf $backupfile
	    if [ -f $backupfile ] ; then
		bzip2 $backupfile
	    fi

	    # From now on only consider unarchived files.
	    rm -f $file_list_file
	    mv $file_list_file.pass $file_list_file
	fi
    done
    echo "Packaging remaining files in $target"
    backupfile="$backupfile_prefix`echo $target | tr / _`.tar"

    cd $target
    grep ^$target $file_list_file | sed -e "s|^$target/|\"|" -e 's/$/"/' | xargs tar rf $backupfile
    if [ -f $backupfile ] ; then
	bzip2 $backupfile
    fi

    rm $file_list_file
done

exit


# The following is the old implementation, which put everything in one archive.

backupfile=/tmp/backup.tar.bz2
tmpbackup=/tmp/backup_tmp

targets=`cat $HOME/.backups/directories | sed /^#/d`

exclude_file=/tmp/exclude2
rm -f $exclude_file

exclusion_args=`cat $HOME/.backups/exclusions | sed -e /^#/d -e '/^$/d' -e 's/^/-not -path "/' -e 's/$/"/'`

rm -f $tmpbackup.tar
for target in $targets ; do
    eval /usr/bin/find $target -type f $exclusion_args | sed -e 's/^/"/' -e 's/$/"/' | xargs tar rvf $tmpbackup.tar
done
echo "Compressing."
bzip2 -9 $tmpbackup.tar

# Swap out archives.
if [ -a $backupfile ] ; then
    mv -f $backupfile /tmp/`basename ${backupfile}`
fi
mv $tmpbackup.tar.bz2 $backupfile
