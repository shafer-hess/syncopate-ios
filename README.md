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

* User can create an account
* User can login to their account
* User can view their profile
* User can see list of their chats
* User can send messages
* User can create groups
* User can add users to a group
* User can add friends
* Users can search for other users
* User receives notifications 
* User can log out

**Optional Nice-to-have Stories**

* User can edit group details
* User can upload a profile picture
* User can upload a group profile picture
* User can send photo messages
* User can send file messages
* User can change their password
* User can update their status
* User can like other user messages
* User can pin chats 

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

## Wireframes
*We only made digital wireframes
![alt text](/Users/emilyou/Desktop/wireframe.png)
<img src="https://drive.google.com/open?id=1rHEQ6lvzF4hRccfk9uaTcxiGLo0TrROM" width=600>

### [BONUS] Digital Wireframes & Mockups
![alt text](https://drive.google.com/open?id=1rHEQ6lvzF4hRccfk9uaTcxiGLo0TrROM "Title")
<img src="https://drive.google.com/open?id=1rHEQ6lvzF4hRccfk9uaTcxiGLo0TrROM" width=600>

### [BONUS] Interactive Prototype
<img src= "http://g.recordit.co/rF4Mxm4y13.gif" width=250>

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
