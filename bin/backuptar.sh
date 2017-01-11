#!/bin/sh

backupfile_prefix=/tmp/backup_

targets=`cat $HOME/.backups/directories | sed /^#/d`

exclusion_args=`cat $HOME/.backups/exclusions | sed -e /^#/d -e '/^$/d' -e 's/^/-not -path "/' -e 's/$/"/'`

file_list_file=/tmp/file_list

backup_subtarget() {
    target=$1
    subtarget=$2
    other_find_args=$3

    cd "$target"
    if [ -d "$subtarget" ] ; then
        echo "Packaging files in $target/$subtarget"
	subtarget_name=`echo $subtarget | tr '/ ' __`
	if [ "$subtarget" = "." ] ; then
	    subtarget_name=`echo $target | tr '/ ' __`
	fi
        backupfile=$backupfile_prefix$subtarget_name.tar.bzip2
	file_list_file=/tmp/file_list_$subtarget_name

	echo "  finding files, removing exclusions"
	rm -f $file_list_file
	eval /usr/bin/find \'$target/$subtarget\' $other_find_args -type f $exclusion_args | sed "s|^$target/||" > $file_list_file

	if [ -s $file_list_file ] ; then
	    echo "  estimating file size"
	    size=`tar c -T $file_list_file | wc -c`
	    echo "    $size bytes"
	    if [ $size -lt 4600000000 ] ; then
		echo "  archiving to $backupfile"
		tar cf $backupfile --bzip2 -T $file_list_file
	    else
		echo "    Archive might not fit on DVD. Split."
		backup_subtarget "$target" "$subtarget" "-maxdepth 1"
		for subsubtarget in $subtarget/* ; do
		    echo "$target" "$subsubtarget"
		    backup_subtarget "$target" "$subsubtarget"
		done
	    fi
	else
	    echo "  no files, skipping"
	fi

	rm -f $file_list_file

	# if [ -f $backupfile ] ; then
	#     size=`du -sg $backupfile | sed 's/^\([0-9]\)*[^0-9].*/\1/'`
	#     echo "File fits in $size GB"
	#     if [ "$size" -gt 4 ] ; then
	# 	echo "File (possibly) does not fit on DVD. Split."
	# 	rm -f $backupfile
	# 	backup_subtarget "$target" "$subtarget" "-maxdepth 1"
	# 	for subsubtarget in $subtarget/* ; do
	# 	    echo "$target" "$subsubtarget"
	# 	    backup_subtarget "$target" "$subsubtarget"
	# 	done
	#     fi
	# fi
    fi
}

for target in $targets ; do
    cd "$target"
    for subtarget in * ; do
    	backup_subtarget "$target" "$subtarget"
    done

    backup_subtarget "$target" . "-maxdepth 1"
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
