# Dumbkey

A dumb password manger

# test cred
w@w.com  
ThisisaStrongPassword1234@

w@w.app
12345678aB!

# Currently working on

# Note
- On login and signup ui freezes because of pwhash memlimit and opslimit

## Features
- [ ] lazy load isar results
- [ ] encrypted index and searching
- [ ] fix caching issues in database handler
- [ ] break up database handler into smaller parts
- [ ] look into putting offline syncing into a isolate
- [x] add syncing user data with firestore
- [x]  add authentication

## Quality of life
- centralize the CRUD operation for the ui
- add password generator in input screen

## UI stuff

- add filtering, sorting, tagging
- add tags to sort by movies/banks/etc or categories
- desktop ui
- add ui to show device is offline or online

## Bugs
- there is weird bug that causes listview to shuffle on delete
- bug in emulator that prevents firestore from working version 33

# possible uis
mobile
- https://www.figma.com/community/file/1120231988229292951
- https://www.figma.com/community/file/1030246241062284627



# Roadmap
[setup ci/cd](https://github.com/vykes-mac/flutter_env/blob/dev/.github/workflows/ci.yml)

add password leak check from [haveibeenpwned](https://haveibeenpwned.com/Passwords)

may be add a date field to model and remind user to update password in a set interval

# done

~~readme update~~

~~added details screen~~

~~added good enough searching~~

~~figure how delete works in offline mode~~

~~add offline queue that syncs with firestore~~

~~add connectivity checks and insert into a persistence queue through isar disable buttons if offline~~

~~add logging~~

~~add desktop grpc/rest api for firestore interface~~

~~add persistence layer for desktop not supported by firedart~~

# windows build steps

cannot install appx without trusted certificate

https://stackoverflow.com/questions/23812471/installing-appx-without-trusted-certificate

From the Windows RT PC, either map the network share or connect the USB drive where you can access the AppPackages folder that contains the app package to install. Use Windows Explorer to open that folder.
Double-tap the certificate file in the folder and then tap Install Certificate. This displays the Certificate Import Wizard.
In the Store Location group, tap the radio button to change the selected option to Local Machine.
Click Next. Tap OK to confirm the UAC dialog.
In the next screen of the Certificate Import Wizard, change the selected option to Place all certificates in the following store.
Tap the Browse button. In the Select Certificate Store pop-up window, scroll down and select Trusted People, and then tap OK.
Tap the Next button; a new screen appears. Tap the Finish button.
A confirmation dialog should appear; if so, click OK. (If a different dialog indicates that there is some problem with the certificate, you may need to do some certificate troubleshooting. However, describing what to do in that case is beyond the scope of this topic.)

