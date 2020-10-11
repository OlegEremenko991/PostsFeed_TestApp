# Posts feed
This is a test task.

## Main requirements

1. Use API: http://stage.apianon.ru:3000/fs-posts/v1/posts
1.1. GET parameters:
* first (Int) - number of posts to load (Default value : 20)
* after (String) - a string with "cursor" which was recieved from previous request (used for pagination system)
* orderBy (String) - sort posts. Options: "mostPopular", "mostCommented", "createdAt".
1.2. Pagination system works like this:
* First request goes without "after".
* To get following pages you need to specify "cursor"-parameter which was recieved from previous request.
* You can load pages if "cursor" is not null.
2. Create a screen with posts feed
3. Load new posts when user scrolls to the last post
4. Add a button to sort posts (by date, by comments and by popularity)
5. All UI elements must be written in code, without storyboard (the main goal is to show basic information from JSON)
6. Open new screen when user taps on post and show some details there (date, author, text)
7. Only standard Apple libraries are allowed to use

## Screenshots

[Link to google drive](https://drive.google.com/drive/folders/1-46PtOf7e3wgMa0RWAxtmzd5FYX15w7O?usp=sharing)
