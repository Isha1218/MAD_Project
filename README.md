# VERTEX
VERTEX is an app that allows for communication among 3 types of individuals: students, teachers, and parents. The goal of this app is to ensure that this communciation is as smooth as possible, so that students can have all of the educational resources to succeeed. Hence our motto: VERTEX...the point to connect.

# Description
* **Student:** students will have the opportunity to see all of their upcoming events, communicate with their teachers, and join new clubs.
* **Parent:** parents will be able to access their child's events and report absences for their child
* **Teacher:** teachers will be able to contact their students, add events for clubs which they are advisers of, and view any upcoming events for these clubs.

# Motivation
We created this project to solve important student needs that apps, such as Remind and Instagram, could not solve themselves. We understand the frusturation that many students may experience as they use these apps, so we wanted to make the experience better. Furthermore, we wanted to get teachers and parents involved because to provide the best educational experience possible. 

# Code
We have used [Flutter](https://flutter.dev/?gclid=CjwKCAiAwc-dBhA7EiwAxPRylOL06vqVy2r9-7r07Bz3MYqicIY42nP4Jw0dpZ_y20WWA4i7uxSiFRoCJNIQAvD_BwE&gclsrc=aw.ds) for our frontend. Flutter allows for development on iOS and Android platforms. We used Firebase for our backend development. Firestore, Firebase Storage, and Google Authorization platforms were used. We also used several packages:

## Packages
* [sync_fusion_calendar](https://pub.dev/packages/syncfusion_flutter_calendar): Creates the framework behind the calendar, allowing users to view upcoming events.
* [flutter_rating_bar](https://pub.dev/packages/flutter_rating_bar): Creates slider rating iwhen user adds feedback.
* [cloud_firestore](https://pub.dev/packages/cloud_firestore): Allows for access to the Firestore database in order to access users, activities, classes, and receive input from the user (event requests and feedback).
* [firebase_core](https://pub.dev/packages/firebase_core): Enables connecting to multiple Firebase apps.
* [firebase_auth](https://pub.dev/packages/firebase_auth): Aunthenticates user using Google provider.
* [firebase_storage](https://pub.dev/packages/firebase_storage): Stores images in Firebase Storage for easy access. 
* [firebase_analytics](https://pub.dev/packages/firebase_analytics): Provides insight on app usage and user engagement.
* [flutter_cupertino_datetime_picker](https://pub.dev/packages/flutter_cupertino_datetime_picker): Allows user to pick a date and a time when requesting an event.
* [smooth_page_indicator](https://pub.dev/packages/smooth_page_indicator): Allows for smooth transition in home page as the user looks through their upcoming events.
* [url_launcher](https://pub.dev/packages/url_launcher): Provides a link for the user to access and be directed to.
* [google_fonts](https://pub.dev/packages/google_fonts): Changes the default font family of app to a Google Font.
* [google_sign_in](https://pub.dev/packages/google_sign_in): Authorizes user based on their Google accounts. 
* [provider](https://pub.dev/packages/provider): Makes widgets more easier and reusable to use.
* [get](https://pub.dev/packages/get): Combines high-performance state management, intelligent dependency injection, and route management quickly and practically.
* [flutter_swiper](https://pub.dev/packages/flutter_swiper): Creates a swipable layout for good UI and cool aesthetics.
* [flutter_slidable](https://pub.dev/packages/flutter_slidable): Allows list item to slide, providing user with additional functionality. 
* [flutter_event_calendar](https://pub.dev/packages/flutter_event_calendar): Displays a calendar with severl views (e.g. monthly, weekly). 
* [syncfusion_flutter_datepicker](https://pub.dev/packages/syncfusion_flutter_datepicker): Lightweight widget that allows users to easily select a single date, multiple dates, or a range of dates.
* [simple_time_range_picker](https://pub.dev/packages/simple_time_range_picker): User can select start and end times. 
* [flutter_email_sender](https://pub.dev/packages/flutter_email_sender): Allows send emails from flutter using native platform functionality.
* [font_awesome_flutter](https://pub.dev/packages/font_awesome_flutter): Offers icons not provided by Flutter.
* [drop_shadow_image](https://pub.dev/packages/drop_shadow_image): Package for creating drop shadow effect of an image, with lots of properties to apply.
* [chat_bubbles](https://pub.dev/packages/chat_bubbles): Flutter chat bubble widgets, similar to the Whatsapp and more shapes.
* [image_picker](https://pub.dev/packages/image_picker): A Flutter plugin for iOS and Android for picking images from the image library, and taking new pictures with the camera.
* [webview_flutter](https://pub.dev/packages/webview_flutter): Directs user to a new link within the app.
* [permission_handler](https://pub.dev/packages/permission_handler): Requests permission from user to access particluar tools on user's phone.
* [flutter_staggered_grid_view](https://pub.dev/packages/flutter_staggered_grid_view): Layed out images in a grid view for the payment system page.
* [motion_tab_bar_v2](https://pub.dev/packages/motion_tab_bar_v2): Represents the tab bar at the bottom of the screen to easily navigate through the pages.
* [rive_splash_screen](https://pub.dev/packages/rive_splash_screen): Adds cool animation effect to splash screen with the Rive software.

# Screenshots

## Screenshots Applicable to Students Only

### Home
<img src="https://github.com/Isha1218/vertex/assets/52381965/55d4748c-d843-46a7-a1ec-46d894a568f3" width="200"><br />

<img src="https://github.com/Isha1218/vertex/assets/52381965/b2ce53f9-6117-40c7-955c-f625dc4e576d" width="200">


### Student Add Events
<img src="https://user-images.githubusercontent.com/52381965/232178913-eafdc0f3-2db2-48e8-b95c-30267043f727.jpeg" width="200">


### ClubHub
<img src="https://user-images.githubusercontent.com/52381965/232179129-fef67118-4c37-4492-81f1-64da7fbbafb4.PNG" width="200">

<img src="https://user-images.githubusercontent.com/52381965/232179144-af06fc21-d550-4a8d-9955-f2aae075fdf6.PNG" width="200">


### Bookkeeper
<img src="https://github.com/Isha1218/vertex/assets/52381965/c59895f6-5a82-48a8-bd91-162973a79b2a" width="200">

<img src="https://user-images.githubusercontent.com/52381965/232179574-4b9822ba-a4e4-4cae-a229-05c551395a03.PNG" width="200">


## Screenshots Applicable to Teachers Only

### Home
<img src="https://github.com/Isha1218/vertex/assets/52381965/8e67f07f-e7b9-479a-938e-40c5d2b96769" width="200"><br />

<img src="https://github.com/Isha1218/vertex/assets/52381965/73efb3aa-2982-4f23-bef9-b3e39ad49b93" width="200"><br />

<img src="https://github.com/Isha1218/vertex/assets/52381965/ff63ac3a-7fd8-40b4-a6ff-eef5e848a728" width="200">


### Add Events
<img src="https://user-images.githubusercontent.com/52381965/232179408-ca0abb6c-7f82-45fe-a09e-f10f1e2b0259.jpeg" width="200">


## Screenshots Applicable to Parents Only

### Home
<img src="https://github.com/Isha1218/vertex/assets/52381965/a1c25917-3655-439d-84b6-7d9143c6d769" width="200">


### Report Absences
<img src="https://user-images.githubusercontent.com/52381965/232179246-6de1da28-bf96-4b41-ae95-3e683d501063.jpeg" width="200">


## Screenshots Applicable to Students, Parents, and Teachers

### Calendar
<img src="https://github.com/Isha1218/vertex/assets/52381965/9691ebf8-5045-4160-a590-c6e7461b7647" width="200">


### Settings
<img src="https://github.com/Isha1218/vertex/assets/52381965/a96b6986-e0b7-4d75-a187-b0e829f1dd3f" width="200">


# Features
* **Upcoming Events:** Lists all of the users' upcoming events based on the activities they are enrolled. The events are shown on a calendar. A description of the event is provided. The dates and times are listed as well. This ensures that the user is up to date on all school-related information.
* **ASB Page:** A separate page just for announcements/events from the school are listed because these tend to be very important. Dates and times of events are listed along with a description of the event. The ASB's Instagram page is also listed.
* **Feedback:** Users can provide feedback about the app, so that we can make future updates for the app. 
* **View Licensing & Terms of Use:** Users can view our licensing & terms of use, so that they are aware of all of the policies associated with our app.
* **Help:** Users can navigate to the help page if they need any help understanding how to access certain elements of the app. 
* **Icons:** Various icons are used throughout the app to ensure that the user is able to easily navigate between the pages and understand what each page does.
* **Photo Messaging:** Students and teachers are able to send photos to each other through our messaging page. This ensures that teachers can be fully involved in the students' learning process.
* **Reporting Absences:** As many parents know, reporting their students' absences can be quite tedious. VERTEX ensures that this process is simple and quick from both parents and administration.
* **Bookkeeping:** School bookkeeping is unorganized and lacks UI to display items being purchases. Vertex's bookkeeping page solves all of these problems.

# Instructions

## Overview:
The purpose of Vertex is to connect teachers, parents, and students on one platform in order to get the best education experience possible. 

## Students: 
As a student, you have access to the following pages:
  **1. Home (home icon):** Displays upcoming events and classes/activities.
  **2. Calendar (calendar icon):** Displays personal and events from activities you participate in.
  **3. ClubHub (information icon):** Displays a list of all clubs organized by several categories.
  **4. Bookkeeper (money icon):** Displays a list of purchasable items at NCHS.
  **5. Settings (settings icon):** Displays all user settings, including pronouns, terms of licensing & use, a feedback page, and so much more.
  * **Sign-In:** Students will be expected sign-in using their apps.nsd.org emails. 
  * **Home Page:** Once the student has been successfully authenticated, they will immediately be brought to a home screen where they will be able to look at their events and their classes/activities. 

### Home Page
This page is meant to provide a snapshot of your events, classes, and activities all in one location for easy access. In this page, you will see:

#### Upcoming Events
You will have access to up to five upcoming events, prioritized by date and time. These events will have the name, description, start time, and end time of the event. An icon is also displayed to provide more information about the event. These events will be displayed on cards. You can swipe through the cards to browse through the different events.

#### Lists of Clubs and Activities
A list of classes and activities that you are currently in will be displayed; each can be accessed by the “classes” and “activities” buttons at the top of lists. Each list item will provide information about the teacher and a helpful icon to go along with it. The classes list item will further have information about the class period. By dragging each list item to the left, you will be presented with the options to either message or email the teacher of a particular class.

**Email**
By pressing on the email option, an email draft will pop up on your screen, addressed to the teacher’s email. The body or subject will not be filled out. You can either send the email or save the email as a draft.

**Messaging**
By pressing on the messaging option, you will be presented with a screen where you can privately message with a particular teacher. This will take the form of a simple chat app, where you will be able to upload images or other media as well as text.

### Calendar Page
The purpose of this page is to see any upcoming events that either you have created or that an activity that you are in has added. In this page, the default calendar mode will show weekly calendar events.
 
#### Browsing Through the Events
You will be able to click through the different dates (switching across days, months, and even years); a subscript on the date will tell you the number of events that you have on that particular day; when you click on the date, a list of your events will show up. The events are color-coded into the following categories: NCHS events (purple), personal events (green), club events (yellow), and sports events (pink). A date that has no events will be labeled as such. To return to today’s date, you can click on the clock icon. 

#### Monthly Calendar View
As you are browsing through your various events, you may also consider viewing the events in the monthly calendar mode by clicking on the calendar icon at the top of the screen. The functionality of the calendar will still be the same. 

#### Add Personal Event
An add icon will be located at the bottom right corner of the screen. When you click this icon, you will be able to add your own event. A form will show on the screen and you will be required to input the following information: Subject of event, details of event, start time (which will display a date and time picker), and end time (which will also display a date and time picker). When you click “submit”, you will be redirected to the calendar page and your event will be displayed at the date chosen. 

### ClubHub
The ClubHub is an area where you can browse through all of the clubs and sports at NCHS in order to get more information about each or to join a particular club. Each item will contain the name, adviser, members, room number, and icon, and of the club. You can browse through the clubs in two different ways:

#### Browse Using Categories
There are six different categories that you can select: Popular, business, technology, art, culture, and sports. These six categories represent a majority of clubs at this school. When you click on a particular category, a list of clubs that belong in this category will be displayed in a column. 

#### Browse Using Search Bar
A search bar will be displayed at the top of the page. When nothing has been searched for, a list of all of the clubs at NCHS will be displayed in a column. As you search for a particular club, the results will filter, until you reach the particular club that you are looking for. 

#### Clicking On the Club
When you click on the club that you would like to join or find more information on, the tags, description, and achievements of the club in addition to all of the information on the previous list item. On this expanded view of the club, you will also be able to:

**View the Club’s Instagram**
An Instagram icon will be displayed at the bottom of the screen. When clicking on this icon, you will be able to see the club’s Instagram posts to get more information.

**Join the Club**
Click on the “join” button, also displayed at the bottom of the screen if this is a club that you are not already a part of. When clicking join, a box will pop up, asking if you have already joined the Remind code (unless the club has no Remind code). If not, a link will redirect you to join the Remind for the particular club.

### Bookkeeper Page
The purpose of the bookkeeper page is to allow students to make purchases (as an alternative to NSD touchbase). A list of all purchasable items will be displayed as a grid. Each grid item has an image of the time, name of the item, and the cost of the item. To browse for the bookkeeper items, a search bar can be used.

#### Browse Using Search Bar
A search bar will be displayed at the top of the page. When nothing has been searched for, a list of all purchasable items at NCHS will be displayed in a grid. As you search for a particular item, the results will filter, until you reach the particular item that you are looking for.

#### Clicking On the Bookkeeper Item
When you click on an item that you would like to purchase, all of the elements from the grid element will be presented along with a description of the item. At the end, a “Buy Now” button will be presented. You can click on it if you decide to go ahead with the purchase.

**Make the Purchase**
When you click buy now, a warning that you must first pay the fine to receive the item will be displayed. You will then have the option to either click cancel or confirm. When you confirm the purchase, the item and fine will be added to your account. If you click cancel, the purchase will not be registered. 

### Settings Page
The settings page is meant to provide an overview information about your account and information about Vertex. In the settings page, you will be able to view:

#### Account Information
This information will be relevant to you. It will include items, such as your name, the type of person you are (“student” in this case), and your pronouns. The only editable field is your pronouns.

**Changing Pronouns**
You will be able to change your pronouns by being redirected to a page where you will be able to input your new pronouns. This is important because this information will be displayed to the individual being messaged.

#### Help and Permissions
These settings will present information about our app, including our licensing & terms of use, these instructions, and a feedback page.

**Give Us Feedback**
If you have a bug, suggestion, compliments, etc. to report you can give us feedback, which we will seriously consider. To give us feedback, you will be redirected to a new page, which will be a form. You will rate the satisfaction you have with Vertex on a scale of 0-10, pick the subject of feedback through a dropdown menu, and add an option comment. When you click the submit button, this feedback will be recorded and we will make sure to consider it. 

#### Logout
The last item on this screen is the logout button. It will log you out of your account and take you back to the sign in page. 


## Parents: 
As a parent, you have access to the following pages:
  **1. Home (home icon):** Displays your children’s upcoming events and a list of your children.
  **2. Calendar (calendar icon):** Displays upcoming events of activities that your children are a part of.
  **3. Settings (settings icon):** Displays all user settings, including pronouns, terms of licensing & use, a feedback page, and so much more.

### Home Page
This page is meant to provide a snapshot of the events that your children are a part of and a list of all your children in one location for easy access. In this page, you will see:

### Upcoming Events
You will have access to up to five upcoming events for your children, prioritized by date and time. These events will have the name, description, start time, and end time of the event. An icon is also displayed to provide more information about the event. These events will be displayed on cards. You can swipe through the cards to browse through the different events.

#### Lists of Classes Children
A list of your children will be displayed. Each list item will have the name of your child. By dragging each list item to the left, you will be presented with the option to report the absence of a particular child. 

#### Report Absences
By pressing on the report absences option for a particular child, you will be redirected to a form, where you will be asked to input information about your child’s absence. This information will be stored and used for administrative purposes. 

### Calendar Page
The purpose of this page is to see any upcoming events that your children are a part of. In this page, the default calendar mode will show weekly calendar events.
 
#### Browsing Through the Events
You will be able to click through the different dates (switching across days, months, and even years); a subscript on the date will tell you the number of events that you have on that particular day; when you click on the date, a list of your events will show up. The events are color-coded into the following categories: NCHS events (purple), club events (yellow), and sports events (pink). A date that has no events will be labeled as such. To return to today’s date, you can click on the clock icon. 

#### Monthly Calendar View
As you are browsing through your various events, you may also consider viewing the events in the monthly calendar mode by clicking on the calendar icon at the top of the screen. The functionality of the calendar will still be the same. 

### Settings Page
The settings page is meant to provide an overview information about your account and information about Vertex. In the settings page, you will be able to view:

#### Account Information
This information will be relevant to you. It will include items, such as your name, the type of person you are (“teacher” in this case), and your pronouns. The only editable field is your pronouns.

#### Changing Pronouns
You will be able to change your pronouns by being redirected to a page where you will be able to input your new pronouns. This is important because this information will be displayed to the individual being messaged.

**Help and Permissions**
These settings will present information about our app, including our licensing & terms of use, these instructions, and a feedback page.

#### Give Us Feedback
If you have a bug, suggestion, compliments, etc. to report you can give us feedback, which we will seriously consider. To give us feedback, you will be redirected to a new page, which will be a form. You will rate the satisfaction you have with Vertex on a scale of 0-10, pick the subject of feedback through a dropdown menu, and add an option comment. When you click the submit button, this feedback will be recorded and we will make sure to consider it. 

#### Logout
The last item on this screen is the logout button. It will log you out of your account and take you back to the sign in page. 


## Teachers: 
As a teacher, you have access to the following pages:
  **1. Home (home icon):** Displays upcoming events and the classes you teach.
  **2. Calendar (calendar icon):** Displays upcoming events of activities that you are the adviser of.
  **3. Settings (settings icon):** Displays all user settings, including pronouns, terms of licensing & use, a feedback page, and so much more.

### Home Page
This page is meant to provide a snapshot of your events and classes all in one location for easy access. In this page, you will see:

### Upcoming Events
You will have access to up to five upcoming events, prioritized by date and time. These events will have the name, description, start time, and end time of the event. An icon is also displayed to provide more information about the event. These events will be displayed on cards. You can swipe through the cards to browse through the different events.

#### Lists of Classes You Teach
A list of classes you teach will be displayed. Each list item will provide information about the class name, class period, and a helpful icon to go along with it. By dragging each list item to the left, you will be presented with the option to message students in the class. 

#### Messaging
By pressing on the messaging option, you will be presented with a screen where you can privately message with individual students in your class. This will take the form of a simple chat app, where you will be able to upload images or other media as well as text. Moreover, you can create announcements, so that the whole class can see your message. 

### Calendar Page
The purpose of this page is to see any upcoming events of activities that you are a part of. In this page, the default calendar mode will show weekly calendar events.
 
#### Browsing Through the Events
You will be able to click through the different dates (switching across days, months, and even years); a subscript on the date will tell you the number of events that you have on that particular day; when you click on the date, a list of your events will show up. The events are color-coded into the following categories: NCHS events (purple), club events (yellow), and sports events (pink). A date that has no events will be labeled as such. To return to today’s date, you can click on the clock icon. 

#### Monthly Calendar View
As you are browsing through your various events, you may also consider viewing the events in the monthly calendar mode by clicking on the calendar icon at the top of the screen. The functionality of the calendar will still be the same. 

#### Add Activity Event
An add icon will be located at the bottom right corner of the screen. When you click this icon, you will be able to add an event of an activity that you are the adviser of. A form will show on the screen and you will be required to input the following information: Subject of event (which will be in the form of a dropdown menu), details of event, start time (which will display a date and time picker), and end time (which will also display a date and time picker). When you click “submit”, you will be redirected to the calendar page and your event will be displayed at the date chosen. This event will also be displayed on the students’ end if they are a part of the activity. 

### Settings Page
The settings page is meant to provide an overview information about your account and information about Vertex. In the settings page, you will be able to view:

#### Account Information
This information will be relevant to you. It will include items, such as your name, the type of person you are (“teacher” in this case), and your pronouns. The only editable field is your pronouns.

**Changing Pronouns**
You will be able to change your pronouns by being redirected to a page where you will be able to input your new pronouns. This is important because this information will be displayed to the individual being messaged.

#### Help and Permissions
These settings will present information about our app, including our licensing & terms of use, these instructions, and a feedback page.

#### Give Us Feedback
If you have a bug, suggestion, compliments, etc. to report you can give us feedback, which we will seriously consider. To give us feedback, you will be redirected to a new page, which will be a form. You will rate the satisfaction you have with Vertex on a scale of 0-10, pick the subject of feedback through a dropdown menu, and add an option comment. When you click the submit button, this feedback will be recorded and we will make sure to consider it. 

#### Logout
The last item on this screen is the logout button. It will log you out of your account and take you back to the sign in page.


# Support
If any help is needed while navigating through the app, please contact: [ishita.mundra@gmail.com](ishita.mundra@gmail.com).

# RoadMap
Future releases include:
* Deployment of app at North Creek High School and further expanding to other schools.
* Push notifications
* Events from classes
* Optimizing Firebase

# Authors and Acknowledgement
Three authors have significantly contributed their time and efforts to this app:
* Ishita Mundra
* Pragya Rana
* Rishitha Ravi
