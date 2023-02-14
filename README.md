# Fix Blocked Port 3306 for MySQL
This script is designed to fix the blocked port 3306 for MySQL.

### Author
This script was created by Hoang Khac Phuc. For questions or feedback, please contact the author at fb.com/hoangkhacphuc.dev.

### Operating system
This script is designed to run on Windows.

### Version
The current version of this script is 1.0.

### Description
This script is intended to fix the blocked port 3306 for MySQL by performing the following actions:

- Check if MySQL is running.
- Check if port 3306 is blocked.
- Check if the current location is `\xampp\mysql`.
- Check if the folder `'./data_old'` exists and delete it.
- Rename the folder `'./data'` to `'./data_old'`.
- Copy the folder `'./backup'` to `'./data'`.
- Create the file `'exclude_folders.txt'` to exclude default folders contained in folder `'./backup'`.
- Create a folder `'./data2'` to contain the folders that need to be converted to `'./data'` temporarily.
- Create the file `'list_folders.txt'` to save the list of folders in `'./data_old'`.
- Get the list of folders in `'./data_old'` and save it to file `'list_folders.txt'`.
- Copy folders from `'./data_old'` to `'./data2'` except the folders in `'exclude_folders.txt'`.
- Copy folders from `'./data2'` to `'./data'` except the folders in `'exclude_folders.txt'`.
- Delete the folder `'./data2'`.
- Delete the files `'exclude_folders.txt'` and `'list_folders.txt'`.

### How to Use
To run this program, you need to download it and unzip it. Then copy the file `'fix_blocked_port_mysql.bat'` and place it in the `'\xampp\mysql`' folder corresponding to where you installed it. Finally, just double click on the 'fix_blocked_port_mysql.bat' file to run it.

>Note: You can find it by opening the Xampp Control Panel and selecting Explorer on the right.

### Postscript
Since Xampp often gets this error but I'm lazy to implement it so I thought of using Batch Script to automate it. However, I'm just learning by doing, so maybe it's not very optimized. If you have any suggestions, please let me know. Thank you!