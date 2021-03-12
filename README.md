<img src="https://user-images.githubusercontent.com/225808/110340787-faf33c00-806c-11eb-8fcd-7b1c3f8c4ae8.png" width="120" alt="App Icon" />

# ladder-client

![circleci](https://circleci.com/gh/kenzan8000/ladder-client.svg?style=shield)

[ladder-client](https://apps.apple.com/us/app/ladder-client/id1317507559) is an iOS client for an open source RSS reader called [Fastladder](https://github.com/fastladder/fastladder).
This app provides more mobile-optimized experience comparing to viewing the RSS reader by a mobile browser.

<img src="https://user-images.githubusercontent.com/225808/110950111-c641f600-8386-11eb-8da8-96ede2d3bdca.gif" alt="ladder-client" />

## Fastladder

<img src="https://user-images.githubusercontent.com/225808/110950188-dfe33d80-8386-11eb-9df4-aee386b07883.jpg" width="600px" alt="Fastladder" />

[Fastladder](https://github.com/fastladder/fastladder) is an innovative RSS reader in a meaning that divides the browsing into two simpler tasks, feed browsing and article reading.
For example, in a usual RSS reader, you would see list of the updated feeds you subscribe to.
Then you dig in the unread articles in a feed, back to the feed list, and iterate them again and again.
On the other hand, [Fastladder](https://github.com/fastladder/fastladder) separates reading each article from the whole task.
It allows you to first focus on <em>pinning</em> the articles you will read.
Later, you just read the <em>pinned</em> articles at once without any task interference.
Besides, the vim-like intuitive key bindings help you get the task done more quickly and less stressfully.

## iOS client

[ladder-client](https://apps.apple.com/us/app/ladder-client/id1317507559) is an iOS client for [Fastladder](https://github.com/fastladder/fastladder).
It aims not to break the original intuitive and stressless RSS reader experience.

The feed browsing and article reading are separated by the tabs.
<img src="https://user-images.githubusercontent.com/225808/110951459-6d735d00-8388-11eb-8f4d-6add7b675adc.jpg" width="600px" alt="tabs" />

There is still a vim-like quick and intuitive interaction when pinning an article from each feed.
<img src="https://user-images.githubusercontent.com/225808/110950608-6566ed80-8387-11eb-8a03-61dcbf857333.gif" alt="feed-detail" />

[ladder-client](https://apps.apple.com/us/app/ladder-client/id1317507559) is technically an ordinary iOS app but at the same time it covers the following essential part of iOS development.
Making this kind of app is maybe good for you to learn them.

- SwiftUI
- Database (CoreData)
- Functional Reactive Programming (Combine)
- Multi-threaded Networking
- Unit Testing
- CI (CircleCI)
