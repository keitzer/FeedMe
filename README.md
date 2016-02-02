## How to install

```
git clone (repo)
pod install
```

Then open .xcworkspace file


## Pods used

```
SVProgressHUD, for loading indicator
Kiwi, for testing
MWFeedParser, for RSS feed parsing
```


## How to use

Just like any other RSS app, simply open it up, hit the refresh button, and start reading!


## Other notes

I wasn't entirely sure what was meant by "The story" on the 2nd VC, so I decided to take the URL from each feed item and just load it up in a web view.

Also, this is the first time I've ever done TDD/BDD/Unit Tests/etc. I started researching and learning on Friday so I apologize in advance if the tests don't make any sense/aren't up to par. I do, however, believe that the code coverage is fairly complete with regards to the funcationality of the public interfaces as well as the "a user should be able to..." style of testing. There may be one or two things that I missed (eg: if the didParseFeedItem correctly parses), but after going over the entire app multiple times it feels pretty solid.

Lastly, I couldn't get the Image comparison test to work when archiving/unarchiving the Article object. Not sure why, but no matter what I tried it kept failing. So I left it commeneted out.