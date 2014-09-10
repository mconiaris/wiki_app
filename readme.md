# wiki_app

##GA WDI NYC (Guildenstern) August Project I

###Overview
WikiApp embraces the concept that information should be free and distributed by means of mutual aid.

This version of a Wiki Web application is an incomplete first draft that allows users to write articles in Markdown and then post them to HTML without any explicit conversion done by the user.

Documents may be added, edited, deleted or viewed, although some features require the user to sign in.

###Technologies Used
This application uses the following gems:
- Sinatra 1.4.5
- Redis 3.1.0
- Redcarpet
- Markdown
- HTTParty

It also uses Google OAuth for authentication as well as Google's Contacts API, Google Cloud SQL, Google Cloud Storage, Google Cloud Storage JSON API and the Google+ API. This appication attmeps to collect only the minimun amount of data neccessary to make it work.

###Deployment Instructions
While seed data is provided, you may wish to populate your own data using redis-server.

Most of the work prior to using this application will need to be done in the [Google Developers Console](https://console.developers.google.com).

There, you will need to request and set the following variables in your server:
- Your client ID as GOOGLE_CLIENT_ID
- Your client secret as GOOGLE_CLIENT_SECRET
- Your redirect URI as GOOGLE_REDIRECT_URI



###User Stories Completed
1. The user goes to the homepage and it has content.
2. The site has a working login field.
3. A user may write a new article and post it to the Wiki..
4. A user may open an article and edit it.
5. A user may open an article and delete it.
6. A user may view 10 articles at a time and click a link to get 10 more until all articles have been displayed.
7. A user may click on a link that displays a particular article.

###Backlog
- in future iterations, once a user signs in, he/she will have the exclusive right to delete an article authored by that person
- in future iterations, version control tracking will be enabled
- in future versions, users will have a profile listing the articles they have written or contributed to.
- the CSS needs some cleanup.
- userID information will be pulled from Google+, saving the user some steps.

###Credit and Legal Stuff
Written by Michael Coniaris. Don't steal my stuff bro, it's not that great yet.
