# dishful-ui

A recipe development app.

Development day 1: 25th July, 2021

### Design Thoughts

- **Why not use a typical tree view for iterations?**
  All iterations are equally important; it does not make sense to hide some because they might
  be considered a _sub_-iteration.
- **Why not copy git diffs to simplify the UI and code?**
  We need additional metadata for each change. Only having that x was removed and y was added
  is not sufficient in the context of recipes - is y replacing x or did you decide not to use 
  x anymore and have started using y in the same iteration (but elsewhere in recipe)? 
  These situatations are handled by the metadata stored for each change on a given iteration.
  There are other reasons:

  - The difference between a recipe and an iteration is unclear.
  - The UI has to show a 'iteration 0' for each recipe which is simply the original recipe. This no longer exists if the recipe meta 
    is the base recipe (more intuitive).
  - This will enable us to use much more human-like language to describe each recipe iteration.
    Instead of '+' and '-', we can say things like 'Use 25ml more milk' and 'Replace mozarella with cheddar'.
    This become particularly important when updating recipe steps.
  - With another data structure representing a change in an iteration, this gives us even more flexibility.
    We can allow the user to give us additional information per change - e.g. a comment or reasoning as to why
    they decided to try a given change.
  - This will use far less storage space. Instead of storing the entire recipe for each iteration we store the changes 
    (which should be tiny in comparision).

### Notes

- **Order of the changes in an iteration matters!**
  E.g. imagine two changes; the first removes an ingredient, the next
  tries to edit that same ingredient; busted! 