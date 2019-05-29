# Directory Comparison

Let's say you've got 2 different dirs, one on an new HDD where you've backed all your files up to, and another on your old HDD that you want to discard.

You want to confirm that all the files from your old drive are contained on your new one.

The problem is, that since copying them to the new one, you've added heaps, rearranged them, put them into a totally different folder structure.

This method gets a list of all files with their name and size (but not path) and compares those 2 lists highlighting any which exist in the old drive but not the new.

```
cd /path/to/old
ls -lA -R | awk '{print $9 " " $5}' | sort | uniq > ~/old.list

cd /path/to/new
ls -lA -R | awk '{print $9 " " $5}' | sort | uniq > ~/new.list

diff -y ~/old.list ~/new.list | grep '<'
```
