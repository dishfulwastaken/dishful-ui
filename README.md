# dishful-ui

A recipe development app.

Development day 1: 25th July, 2021

### TODO
- Make the new recipe iterations listeners work; solution would be to use cloud firestore emulator;
  Would be best to start making scripts (maybe in another repo) for running the whole thang
- Create users, add user ID to some domain models
- Login page & ability to create a user, look into how we comply with GDPR,
  I think it will just involve giving users the ability to see all the data we store 
  on them. 
  BOTH TIERS of the app will involve user creation & login
- I need to add my own data to UserCredentials... how do i do this? (is pro / subscription end date)
- Error handling everywhere! e.g. sign in, init flutterfire, etc, using Result<T>
  (see bookmarks)
- Web support: premium users only so it will
    - ask for login
    - once logged in, check if user has an active subscription
    - if not, display message like this is a pro users only feature,
      upgrade to premium through the app...
    - if so, display the app as usual!
- Cloud functions is probably going to hit the free tier limit first.
  We need to try our very best to NOT use it when not needed. To that end,
  we should be caching html that we get back from it. For example, lets say we 
  request html for recipeA. After that we cache the response for maybe 1 week. 
  If the user wants to make another recipe iteration based on the first one, we see
  the cached data is still valid, so we use that instead of using FunctionsService.fetchHtml
- Make Firebase DB initialization lazy - do not call init until either:
    - the user enters a page which is meant for shared data or
    - a request is made to PublicDb 
- Enable Firebase caching to avoid making as many requests (via FlutterFire -> enablePersistence)
- Unify imports of my own dart files to either all use package: or none
- Base editable: on save callbacks