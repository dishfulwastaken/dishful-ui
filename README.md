# dishful

A recipe development app.

Development day 1: 25th July, 2021

### TODO
- Change DB accesses to similar to firestore, e.g. LocalDb.instance.recipe
- Change structure of HiveDb to match that of FirebaseDb
    - HiveDb needs the same hierarchy, e.g. there should **not** be a RecipeStepClient
     that is capable of interacting with only RecipeSteps.
    - Firebase is the priority; make this work for firebase and then implement the same
      structure in hive for a smooth, predictable database API.
- Create base editable widget! Extending children have the behaviour:
    - If not editable, on long press, do a little shake left and right.
    - Else, on long press:
        - Replace the child with an editable version of the child of same 
          dimensions. E.g. text -> text area, enum -> select, int -> +/- buttons
        - On blur of the editable input, start saving to DB (localDB AND if
          shared to firestore).
        - Once the save has been successful, display a snackbar/notification to
          report the result, e.g. successfully saved or error.
