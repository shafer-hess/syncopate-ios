# syncopate-ios
Port of Syncopate onto iOS Platform

Group Project - README Template
===

# Syncopate

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
### **Reinventing how Purdue students communicate with each other.**

That is the goal here on our Syncopate platform. We personally do not see a reason to have more than one platform to message other students with. Whether it be Slack, GroupMe, SMS, Discord, or Facebook, students at Purdue currently do not have a standardized messaging platform which is commonly available in the work industry.

Syncopate provides a unified solution for all communication between Purdue students. Skip the hassle of coordinating which messaging platform to use during group projects. Avoid providing other students with your personal social media accounts like Facebook or Snapchat. By choosing to use Syncopate, which is dedicated only for messaging within Purdue's student body, the only information you need to expose is basic student contact information.

### App Evaluation
- **Category:** Social
- **Mobile:** Real-time chat application
- **Story:** Allow Purdue students to communicate without the need to share personal information (ex: phone number, personal email, etc)
- **Market:** Purdue University students
- **Habit:** Users can send messages (idk like any other form of communication)
- **Scope:** Perdue Farm students

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [x] User can create an account
- [x] User can login to their account
- [ ] User can view their profile
- [x] User can see list of their chats
- [x] User can send messages
- [ ] User can create groups
- [ ] User can add users to a group
- [ ] User can add friends
- [x] Users can search for other users
- [ ] User receives notifications 
- [x] User can log out

**Optional Nice-to-have Stories**

- [ ] User can edit group details
- [ ] User can upload a profile picture
- [ ] User can upload a group profile picture
- [x] User can send photo messages
- [ ] User can send file messages
- [ ] User can change their password
- [ ] User can update their status
- [ ] User can like other user messages
- [ ] User can pin chats 

### 2. Screen Archetypes

* Registration Screen
   * User can create an account
* Login Screen
   * User can login to their account
* Profile Screen
    * User can view their profile
* Change Password Modal
    * User can change their password
* Chats List Screen
    * User can see list of their chats
* Chat Screen
    * User can send messages
    * User can add users to a group
* Create-group Modal
    * User can create groups
* Friend Screen
    * User can see a list of their friends
* Add-Friend Modal
    * User can add friends
    * User can search for other users
* Notification Modal
    * User receives notifications

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Profile Screen 
* Chats List Screen
* Friends Screen

**Flow Navigation** (Screen to Screen)

* Registration Screen
    * Login Screen or Profile Screen (?)
* Login Screen
    * Registration Screen -> for unregistered users
    * Profile Screen -> for registered users
* Profile Screen
    * Change Password Modal
* Chats List Screen
    * Chat Screen -> after selecting a chat
    * Create Group Modal
* Friends Screen
    * Returns list of friends
    * Add Friends Modal
    * Notification Modal
    
## Sprint 1
- [x] User can create an account
- [x] User can login to their account
- [x] User can log out

<img src="https://media0.giphy.com/media/eMUpbyZSivxT3vEf7U/giphy.gif?cid=4d1e4f2971d6e42fecf9a5ef03379186106312811a03c131&rid=giphy.gif" width=250>
Link to full gif: https://i.imgur.com/A0HKRo1.gif

## Wireframes
*We only made digital wireframes <br>
<img src="https://i.imgur.com/gB18OyA.png" width=600>

### [BONUS] Digital Wireframes & Mockups
<img src="https://i.imgur.com/gB18OyA.png" width=600>

### [BONUS] Interactive Prototype
<img src= "http://g.recordit.co/rF4Mxm4y13.gif" width=250>

## Schema 
### Models
#### User
| Field | Type | Description |
| --- | --- | ---|
| id | int | unique user id (primary key) |
| password | string | user's account password |
| email | string | user's email |
| first_name | string | user's first name |
| last_name | string | user's last name |
| profile_pic_url | string | stored url of user's profile picture |
| available | bool | user's availability |

#### Friend
| Field | Type | Description |
| --- | --- | ---|
| id | int | unique friend-pair id (primary key) |
| user_id | int | session user's id (foreign key) |
| friend_id | int | friend's user id (foreign key) |

#### Group
| Field | Type | Description |
| --- | --- | ---|
| id | int | unique group id (primary key) |
| owner | int | user id of the user who created the group (foreign key) |
| name | string| group name |
| description | string | group description |
| profile_pic_url | string | url of group profile picture |
| direct_message | bool | direct message |

#### User Group
| Field | Type | Description |
| --- | --- | ---|
| user | int | session user id (foreign key) |
| group | int | group id (foreign key) |
| pinned | bool | pinned group |
| archived | bool | archived group |
| deleted | bool | deleted group |

#### Cookie
| Field | Type | Description |
| --- | --- | ---|
| user | int | session user id  |
| cookie_token | string | cookie identifier |

#### Message 
| Field | Type | Description |
| --- | --- | ---|
| id | int | unique message id (primary key) |
| user | int | user id (foreign key) |
| group | int | group id (foreign key) |
| content | string | message's content |
| rich_content | bool | message contains non-plaintext content |
| rich_content_url | string | message's rich content url |
| deleted | bool | message deleted |
| created | DateTime | message's creation date and time |

#### Request 
| Field | Type | Description |
| --- | --- | ---|
| id | int | unique request id (primary key) |
| sender | int | session user's id (foreign key) |
| reciever | int | requested friend's user id (foreign key) | 

### Networking
*This is our own API we built using AWS

| Request | Endpoint | Description |
| --- | --- | --- |
| POST | /register | returns first name, last name, email and password |
| POST | /login | returns a session id (cookie) |
| GET | /identify | gets session user's information |
| POST | /upload-avatar | uploads avatar |
| GET | /my-avatar | gets user's uploaded avatar |
| POST | /add-message | returns message sent |
| POST | /get-messages | returns list of messages from corresponding group |
| POST | /create-group | creates a new group |
| POST | /get-user-group | returns all groups the session user is in and all users in those groups |
| POST | /add-user | adds a new user to the database |
| POST | /requests | returns a list of all incoming requests for the session user |
| POST | /sent-request | returns list of all sent request for the session user |
| POST | /send-request | sends friend request to another user |
| POST | /request-action | returns session user's response to request |
| POST | /search-users | returns list of users whose name or email is contained the the search query |
| POST | /logout | deletes session cookie |
| POST | /load-friends | returns list of session user's friends and their info |
|  | /delete-friend | deletes friend from session user's friends |
| POST | /pin-chat | pins a group chat for session user |
| POST | /set-availability | sets user's availability |
| GET | /get-availability | gets user's availability |
| POST | /change-password | change and updates session user's password |
| POST | /edit-group-name | edit and update group name |
| POST | /edit-group-description | edit and updates group description |
