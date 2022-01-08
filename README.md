# dishful-ui

A recipe development app.

Development day 1: 25th July, 2021

### TODO
- move to next phase of recipe ingress progress
- Error handling everywhere! e.g. sign in, init flutterfire, etc, using Result<T>
  (see bookmarks)
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
- Create base editable widget! Extending children have the behaviour:
    - If not editable, on long press, do a little shake left and right.
    - Else, on long press:
        - Replace the child with an editable version of the child of same 
          dimensions. E.g. text -> text area, enum -> select, int -> +/- buttons
        - On blur of the editable input, start saving to DB (privateDb AND if
          shared to firestore).
        - Once the save has been successful, display a snackbar/notification to
          report the result, e.g. successfully saved or error.
