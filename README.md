# dishful-ui

A recipe development app.

Development day 1: 25th July, 2021

### TODO
- Pro feature widget wrapper
- Make masonry grid responsive? e.g. increase column count with larger widths
- Make recipes list a sliver list so the header moves up on scroll
- Handle firestore error that is raised when trying to restart emulator on hot restart
- See if we can use StadiumBorder EVERYWHERE that we use an overly large
  border radius.
- Start recipes page
  - start using parallax animation, blobs, staggered grid views all in one ;D
- Start planning swooshes
- Enable offline usage?? I know there is some option in firebase, but should we consider
  doing something like using privateDb while no connection? 
- Give keys to widgets!!!
- Look into how we comply with GDPR,
  I think it will just involve giving users the ability to see all the data we store 
  on them. 
- Email verification before upgrading account
- Error handling everywhere! (see bookmarks)
- Web support: pro users only so it will
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
- Use selects to watch only the parts that we need