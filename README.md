# Posts feed
This is a test task. Below you can read the requirements.

## Main requirements

1. Use API: http://stage.apianon.ru:3000/fs-posts/v1/posts
2. GET parameters:
* first (Int) - number of posts to load (default value is 20)
* after (String) - a string with "cursor" used for pagination system
* orderBy (String) - sort posts. Options: "mostPopular", "mostCommented", "createdAt".
3. Create a TableView with posts feed
4. Load new posts (more pages) when user scrolls to the last post. Use this rules:
* First request goes without "after"
* To get more pages you need to specify "cursor"-parameter which was recieved from previous request
* You can keep loading pages while "cursor" is not nil.
5. Add a button to sort posts (by date, by comments and by popularity)
6. All UI elements must be written in code, without storyboard (the main goal is to show basic information from JSON)
7. Open new screen when user taps on post and show some details there (date, author, text)
8. Only standard Apple libraries are allowed to use

## Screenshots

[Link to google drive](https://drive.google.com/drive/folders/1-46PtOf7e3wgMa0RWAxtmzd5FYX15w7O?usp=sharing)
