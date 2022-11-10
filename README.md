# Unalgorithm

Unalgorithm is an app that gathers your Youtube subscriptions to help you get away from the algorithm
## To Use
*This app is still in development, you can install it using the debug bridge on android/iOS, but bugs should be expected.* 

- After installing the app press the plus button
- Copy and paste a Youtube channel you'd like to follow into the field, and press save!

![Subs Page](https://github.com/Tw33t3r/un-algorithm/blob/main/screenshots/subs.png?raw=true=x200)
- Your Youtube videos will be automatically gathered (Timer is currently set to every 6 hours) Or you can scroll down to refresh on the home page

![Subs Page](https://github.com/Tw33t3r/un-algorithm/blob/main/screenshots/videos.png?raw=true=x200)
- Press the fullscreen button to view the video in full screen

## TODO

### Major
 - Currently there is no easy way to import youtube subscriptions. Youtube doesn't export any api, Scraping the subscriptions page of a public channel only supplies the first 20 or so channels. This is a major problem with UX as a user has to copy each of their youtube subscriptions by hand.
 - The video playback page uses flutter's orientation manager which rebuilds the page, I don't think there's a native way to re-orient webviews so some redesign may be necessary to prevent rebuild during video playback.

### Minor
 - It's probably unnecessary and distracting to have the full embed for a video available on the home page, some other way to represent the video would be good.
 - Delete button ends up underneath the add submenu, perhaps push to the top of the page instead.
 - Specify how often youtube videos are grabbed.

### Features
- Add download from specific date
- Better Styling
- Search videos from creator
