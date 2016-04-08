#AnkiHub*

## User Stories

The following **required** functionality is completed:

- [ ] User presses sync button to update their flash cards, and upload flashcards they made.
- [ ] User sees a profile page with how well they are doing studying for each deck.
- [x] User can subscribe to decks.


The following **optional** features are implemented:

- [ ] User can post issues to a card or deck to start a conversation. 
- [ ] User can send a download link to friends in messenger.
- [ ] User can create cards and add images to those cards. 
- [ ] Add ads

##Parse Server
[ankihubparse.herokuapp.com](ankihubparse.herokuapp.com)

##Models
```
User
{
username:"",
decks:[""],
}

Deck
{
"gid":"username:did",
"did":"did",
"desc": "Description of Deck",
"name": "Deck's Native Name",
"keywords":["key","word"],
"ispublic":true,
"cids":["username:did:cid"],
"cards":[
<CardObject>
],
"owner":"username",
"children":["username:did"],
"subscribers":["username"],
"collaborators":["username"],
}

Card
{   
"session_token":""
"gid":"username:did",
"cid":"cid",
"front":"Question",
"back":"<span>Answer</span>",
"tags":[],
"notes":[],
"keywords":[]
}

Transaction
{
"query":"GETACTIONS",
"id":"11",
"done":true,
"data":[{{id}, {data}}, {2, {data}}, {5, {data}}, {4, {data}}]
}


```

##Considerations
###What is your product pitch?
Github for flashcards. 

Medical students make thousands of flashcards that they need to study and share with their classmates.
We want to make an app that can store all these cards in the cloud, and let them download the app at will.
The should also be able to modify any card and have a conversation about a card's content. 

It has the following core flows.

1. User Can login/signup
2. User Can see all decks they own, and search for publically available decks.
3. User Can download decks for offline use
4. User Can start a study session with decks.
5. User Can modify a card if the content is worong. And submit an issue to fix it. 
    - Card content is HTML so users should be able to add images and elements as they see fit
6. User Can synch the deck if they are a collaborator or fork it to make it their own.
7. User Can send the link to a deck through imessage for a friend to download a deck.

###What are the key functions?
1. Download and Sync Decks
2. Edit Cards

###What screens will each user see?
1. Login Screen
2. Deck List/Search
3. Card view/ Modal to edit card

###What will your final demo look like?
Check anki-wireframe.png

###Describe the flow of your final demo
1. Person Signs up
2. Person downloads a deck with over 1000 cards.
3. Person modifies a card.
4. Person sends download link to friend. 
5. Friend downloads deck. 

###What mobile features do you leverage?
1. Sending Messages
2. Photos.
3. Gesture Recognizers.
4. Push notifications. 

###What technical features do you need help or resources for?

## License

Copyright [2016] [David Ayeke]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
