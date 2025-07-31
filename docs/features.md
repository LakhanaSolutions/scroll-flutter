### Reviews Section

-   **[pending]** Create a reusable 'Add a review' card widget to be placed on the Playlist, Author, and Narrator pages. This card should include an "All Reviews" button.
-   **[pending]** Create a dedicated "Reviews" page that can be accessed from the Playlist, Author, or Narrator pages.
    -   **[pending]** The page should display the total number of ratings and reviews.
    -   **[pending]** It should list all reviews, with each review showing the reviewer's name, their rating, the review text, and buttons for upvoting/downvoting.
    -   **[pending]** At the top of the reviews list, there should be a "My Review" section.
        -   **[pending]** If the user has already submitted a review, it should display their rating and review with an "Edit" button.
        -   **[pending]** If the user has not yet reviewed, it should show rating icons and a three-line text input field for writing a review.
-   **[pending]** Implement a restriction so that a user can only rate and review content after they have listened to more than 50% of it.

### Bugs

-   **[pending]** On Android, when playing media, tapping "Add Note" does not pause the playback on the first attempt. The user must navigate back and tap it again for the media to pause.
-   **[pending]** On iOS, tapping "Add Note" pauses the media correctly the first time. Navigating back causes the media to resume automatically. However, tapping "Add Note" again will pause the media, but it will not auto-resume upon navigating back.
-   **[pending]** On the "Verify Email" page, entering an invalid OTP messes up the UI. Subsequently, removing any digit from the input field incorrectly triggers navigation to the Welcome screen, which appears on top of the current screen.

### Improvements

-   **[pending]** For the `PremiumTrial` widget: remove its shadow and change the background to use the gradient defined for the premium plan.

