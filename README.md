# dishful

A recipe development app.

Development day 1: 25th July, 2021

/**
 * TODO: Change DB accesses to similar to firestore, e.g. LocalDb.instance.recipe
 * TODO: see if there is a generic client class for firestore that we could try 
 * to implement for hive.
 * TODO: Create base editable widget! Extending children have the behaviour:
 *   - If not editable, on long press, do a little shake left and right.
 *   - Else, on long press:
 *     - Replace the child with an editable version of the child of same 
 *       dimensions. E.g. text -> text area, enum -> select, int -> +/- buttons
 *     - On blur of the editable input, start saving to DB (localDB AND if
 *       shared to firestore).
 *     - Once the save has been successful, display a snackbar/notification to
 *       report the result, e.g. successfully saved or error.
 */