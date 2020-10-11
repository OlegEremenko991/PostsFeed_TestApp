# Posts feed
This is a test task.

## Main requirements

1. Use API: http://stage.apianon.ru:3000/fs-posts/v1/posts
2. GET parameters:
* first (Int) - number of posts to load (default value is 20)
* after (String) - a string with "cursor" used for pagination system
* orderBy (String) - sort posts. Options: "mostPopular", "mostCommented", "createdAt".
3. Pagination system works like this:
* First request goes without "after"
* To get more pages you need to specify "cursor"-parameter which was recieved from previous request
* You can keep loading pages while "cursor" is not nil.
4. Create a screen with posts feed
5. Load new posts (more pages) when user scrolls to the last post
6. Add a button to sort posts (by date, by comments and by popularity)
7. All UI elements must be written in code, without storyboard (the main goal is to show basic information from JSON)
8. Open new screen when user taps on post and show some details there (date, author, text)
9. Only standard Apple libraries are allowed to use

## Screenshots

[Link to google drive](https://drive.google.com/drive/folders/1-46PtOf7e3wgMa0RWAxtmzd5FYX15w7O?usp=sharing)
