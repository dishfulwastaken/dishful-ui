# dishful-ui

A recipe development app.

Development day 1: 25th July, 2021

### TODO
- Start recipes page
  - use solomon bar for tabs
  - start using parallax animation, blobs, staggered grid views all in one ;D
  - maybe just show the avatar and onclick go to a profile page which has settings in it...
- Start planning swooshes
- Enable offline usage?? I know there is some option in firebase, but should we consider
  doing something like using privateDb while no connection? 
- Use AsyncValue instead of Result so we dont need any magic values for loading states!
- Give keys to widgets!!!
- Look into how we comply with GDPR,
  I think it will just involve giving users the ability to see all the data we store 
  on them. 
- Email verification before upgrading account
- Error handling everywhere! e.g. sign in, init flutterfire, etc, using Result<T>
  (see bookmarks)
- Web support: premium users only so it will
  - ask for signIn
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
- Enable Firebase caching to avoid making as many requests (via FlutterFire -> enablePersistence)
- Unify imports of my own dart files to either all use package: or none
- Base editable: on save callbacks