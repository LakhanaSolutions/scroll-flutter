You are a database architect. Your task is to design a Prisma schema for a new review and rating system based on the following requirements.

### **Core Functional Requirements:**

1.  **Reviewable Content:** Users can rate and review individual audiobooks.
2.  **Rating:** A rating is a score, for example, from 1 to 5.
3.  **Review:** A review is a text comment associated with a rating.
4.  **One Review Per User:** A user can only write one review per audiobook. They should be able to edit their existing review.
5.  **Review Voting:** Any user can upvote or downvote any review (but not their own). A user can only cast one vote (either an upvote or a downvote) on a specific review.
6.  **Business Logic Restriction:** A user must have listened to more than 50% of an audiobook before they are allowed to submit a review for it.

### **UI & Data Display Requirements:**

-   The system needs to display aggregated rating information (e.g., average rating and total number of reviews) for audiobooks, authors, and narrators.
-   On a review page, a list of all reviews for a piece of content will be shown.
-   Each review in the list must display the reviewer's name, their rating, the review text, and the total upvote/downvote count.

### **Prompt:**

Based on the requirements above, create the necessary Prisma schema models.

**Instructions:**

1.  **Define a `Review` model.** This model should store the rating and text. It must be linked to both the `User` who wrote it and the `Audiobook` it pertains to. Ensure that a user can only review an audiobook once.
2.  **Define a `ReviewVote` model.** This model should track the votes on reviews. It needs to link to the `User` who voted and the `Review` that was voted on. It should store whether the vote is an "UPVOTE" or a "DOWNVOTE". Ensure a user can only vote once per review.
3.  **Update Existing Models (if necessary):** Add the necessary relation fields to the existing `User` and `Audiobook` models to connect them to the new review models.

**Assumed Existing Models:**

You can assume the following models already exist. You do not need to define them, but you must use them to create the relationships.

```prisma
model User {
  id       String @id @default(cuid())
  // ... other user fields like name, email, etc.
  
  // Add relation to reviews written by the user
  // Add relation to votes cast by the user
}

model Audiobook {
  id    String @id @default(cuid())
  // ... other audiobook fields like title, authorId, narratorId, etc.
  
  // Add relation to reviews for this audiobook
}

// You can also assume Author and Narrator models exist
// and are linked to the Audiobook model.
```

Please provide the complete Prisma code for the new `Review` and `ReviewVote` models, as well as the lines that should be added to the `User` and `Audiobook` models to establish the relationships.

