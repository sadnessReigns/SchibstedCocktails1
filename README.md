# SchibstedCocktails
**Rant**

Apologies, but I was confused by the "3 days deadline, 1 hour expectation". So I decided to treat task as-if I am in an R&D stage, and create 2 projects - first I gave myself a day of work, second I gave myself 1 hour exactly. This one is first. 
I treated it like an application that is supposed to grow in future, despite right now being simple.

``Project Architecture``
- 
Modular with enough scalability to it to grow over time into a fully clean. However, going full-on with scalability, as-if tomorrow this grows to instagram app size would be detrimental, so some code-related aspects are in their infant stage, some are not abstracted fully to support large-scale project. This was done intentionally, since this is test assignment, and my goal was to simply demonstrate certain techniques and skills, rather than have a production-ready project. Even tho I would personally deem this project as production-ready, just not production-perfect.

``Naming convention``
-
SC prefix stands for SchibstedCocktails, and is there to prevent potential dependency name intersections that happen often. Also allows for immediate distinction between in-house packages and third-party. E.g. useful if SCComponents is another repo and is in fact imported via network rather than being included as a local package.

``How user's creds are stored?``
-
Keychain!

``Navigation``
-
Executed via coordinators pattern.


``Modules:``
-
- **SCNetworking**:
  - responsible for performing networking calls;
  - contains SCNetworkingProtocols library, that exposes networking protocols for mocking/testing/injecting purposes and network-related data models;
  - contains SCNetworking itself that is meant to be used within the main target to instantiate services/pass dependencies down the injection chain.
 
- **SCLogin**: 
  - responsible for signing user in;
  - contains UI for the login flow written on SwiftUI and bridged to a view controller to be used within UIKit-first project;
  - since there was no specific sign up/in API, I decided to go 'creative' and simply call the main API. I decided to go that route to show off some components work and SwiftUI performance, despite this essentially doubles amount of calls needed to app to function (from 1 to 2), and it is also a full-on Rest call without pagination, which returns a full array of data, we should treat it as a PoC instead of a finished ground for the app; later on this call could easily be replaced by a sign in/up API.

- **SCCommon**:
  - a package with commonly shared functionality that is likely to be imported into 90% of product modules (such as SCLogin).

- **SCComponents**:
  - contains UI components.

- **SCCocktailBar**:
  - responsible for displaying a collection cocktails.

``Misc``
-
Project contains example test coverage and a custom test plan with certain modules tests included.

``What I'd like to improve?``
- 
Thanks for asking! :D 
First things first - tests coverage as close to 100% as possible. Snapshot tests for UI components. Snapshot tests for product modules (SCLogin and SCCocktailBar).
A custom session instead of a plain wrapper. 
Smarter caching with flexible expiration policy, that would allow an offline mode and seamless offline-online transition.
Transition to https and actual challenge response instead of a header-based auth.
Proper encryption of user data to avoid sending it raw.
Dig deeper into first keyboard invocation system lag and fix it if possible (considering it's an iOS bug, probably chances are not great, but I'd like the keyboard 'prewarm' to go).
The app is way to small to introduce a more complex and scalable design pattern, but if it was about to grow I'd choose VIP+Re or MVVM+Re with well abstracted protocols for main actors (VC, VM, Interactor etc), and well-designed base classes that automate majority of automatic updates.
A proper git repo. Unfortunately I forgot to lead with that, but I decided that re-doing everything and adding files and commits artificially is cheating, so unfortunately, leaving it as it is.
