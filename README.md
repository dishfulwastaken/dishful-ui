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
- **How does the role-based authorization work?**
  A user should not have access to a recipe with only the recipe ID; they must be either the owner or a guest in one of it's collabs.

  Collabs are objects that represent the sharing of a recipe. They store data such as the owner's user ID, the 
  guest user ID, the role that the guest has, etc. Each recipe has a list of collabs that are in effect for that recipe. 

  When writing security rules, the most useful information that we have to authorize access is the data being requested and the
  requesting user ID. We cannot pass additonal information. 

  To authorize a request, we first check if the requested data (recipe) user ID property matches the requesting user ID. If so,
  they own the recipe; grant full access.
  Only if this is not the case, check if the requested data (recipe) collabs property contains any collabs where the guest ID matches
  the requesting user ID. If so, the recipe has been shared with them and they have access to read (at the very least).

  Now let's talk about the main queries we need to make in relation to shared recipes:

  1. *Get all recipes that have been shared with me.* <br/>
     This is the more difficult query, but it is still straight forward. 
     We are already going to make a request for all recipes that the user has access to (using the same
     logic as we did above). Then, we can simply filter this list of recipes on the client side to only include
     those in which we are a guest.

  2. *Get all users that I have shared this recipe with (and what their roles are).* <br/>
     This becomes trivial because collabs are stored on a recipe; given the recipe, we can directly access the
     collabs property. 

### Notes

- **Order of the changes in an iteration matters!**
  E.g. imagine two changes; the first removes an ingredient, the next
  tries to edit that same ingredient; busted! 