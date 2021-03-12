# gmail_monitor
Monitor for automated emails to send commands.

This repo enables you to command your Amazon firestick or other device thru email, if you tie into https://ifttt.com/discover you can use your Google home to command your Amazon firestick or other device.

# Dependencies (a touch of crazy)
```
sudo apt-get update
sudo apt-get install curl
sudo apt-get install python-pip
sudo pip install oauth2client
```

You will need to create credentials for this program to access gmail, see https://developers.google.com/gmail/api/auth/about-auth for details.

Update gmail_monitor.sh replacing ENTER_CLIENT_ID_HERE, and ENTER_SECRET_HERE with credentials.

Once you have credentials setup use the generate_refresh_token.py (modified for gmail version of https://github.com/googleads/googleads-python-lib/blob/master/examples/dfp/authentication/generate_refresh_token.py) to create tokens and create a file called *.meta*.  Copy the token output of generate_refresh_token.py to the first line of *.meta* and the refresh token to the second line. 

Now you will need to setup an action script, gmail_monitor.sh assumes automated emails (from yourself) will be in format *aut0m8:action args:3nd* and after parsing email `action.sh args` will be called.  For example, *aut0m8:firestick trolls:3nd* will call `firestick.sh "trolls"` (if you have firestick.sh call https://github.com/jpward/firestick_text_input then you can use email to start shows on Amazon firestick.)

If you setup https://ifttt.com/discover to send emails from your Google home now you can command Google assistant to play shows on your Amazon firestick.

# Architecture
High level diagram of components and data flow
![High-level-diagram](/imgs/google_home_to_firestick.jpg)

Repos providing functionality above:
- Firestick control - https://github.com/jpward/firestick_text_input
- Open garage door - https://github.com/jpward/gdoor_server
- Play music from youtube over chromecast - https://github.com/jpward/yt-2-chromecast
- Play error message over chromecast - https://github.com/jpward/text-2-chromecast
