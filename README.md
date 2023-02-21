# VERTEX
VERTEX is an app that allows for communication among 3 types of individuals: students, teachers, and parents. The goal of this app is to ensure that this communciation is as smooth as possible, so that students can have all of the educational resources to succeeed. Hence our motto: VERTEX...the point to connect.

# Description
* **Student:** students will have the opportunity to see all of their upcoming events, communicate with their teachers, and join new clubs.
* **Parent:** parents will be able to access their child's events and report absences for their child
* **Teacher:** teachers will be able to contact their students, add events for clubs which they are advisers of, and view any upcoming events for these clubs.

# Motivation
We created this project to solve important student needs that apps, such as Remind and Instagram, could not solve themselves. We understand the frusturation that many students may experience as they use these apps, so we wanted to make the experience better. Furthermore, we wanted to get teachers and parents involved because to provide the best educational experience possible. 

# Code
We have used [Flutter](https://flutter.dev/?gclid=CjwKCAiAwc-dBhA7EiwAxPRylOL06vqVy2r9-7r07Bz3MYqicIY42nP4Jw0dpZ_y20WWA4i7uxSiFRoCJNIQAvD_BwE&gclsrc=aw.ds) for our frontend. Flutter allows for development on iOS and Android platforms. We used Firebase for our backend development. Firestore and Google Authorization platforms were used.

# Screenshots

# Packages
* [sync_fusion_calendar](https://pub.dev/packages/syncfusion_flutter_calendar): Creates the framework behind the calendar, allowing users to view upcoming events.
* [flutter_rating_bar](https://pub.dev/packages/flutter_rating_bar): Creates slider rating iwhen user adds feedback.
* [cloud_firestore](https://pub.dev/packages/cloud_firestore): Allows for access to the Firestore database in order to access users, activities, classes, and receive input from the user (event requests and feedback).
* [firebase_core](https://pub.dev/packages/firebase_core): Enables connecting to multiple Firebase apps.
* [firebase_auth](https://pub.dev/packages/firebase_auth): Aunthenticates user using Google provider.
* [firebase_analytics](https://pub.dev/packages/firebase_analytics): Provides insight on app usage and user engagement.
* [flutter_cupertino_datetime_picker](https://pub.dev/packages/flutter_cupertino_datetime_picker): Allows user to pick a date and a time when requesting an event.
* [smooth_page_indicator](https://pub.dev/packages/smooth_page_indicator): Allows for smooth transition in home page as the user looks through their upcoming events.
* [url_launcher](https://pub.dev/packages/url_launcher): Provides a link for the user to access and be directed to.
* [google_fonts](https://pub.dev/packages/google_fonts): Changes the default font family of app to a Google Font.

# Features
* **Upcoming Events:** Lists all of the users' upcoming events based on the activities they are enrolled. The events are shown on a calendar. A description of the event is provided. The dates and times are listed as well. This ensures that the user is up to date on all school-related information.
* **ASB Page:** A separate page just for announcements/events from the school are listed because these tend to be very important. Dates and times of events are listed along with a description of the event. The ASB's Instagram page is also listed.
* **Feedback:** Users can provide feedback about the app, so that we can make future updates for the app. 
* **View Licensing & Terms of Use:** Users can view our licensing & terms of use, so that they are aware of all of the policies associated with our app.
* **Help:** Users can navigate to the help page if they need any help understanding how to access certain elements of the app. 
* **Icons:** Various icons are used throughout the app to ensure that the user is able to easily navigate between the pages and understand what each page does.
* **Photo Messaging:** Students and teachers are able to send photos to each other through our messaging page. This ensures that teachers can be fully involved in the students' learning process.
* **Reporting Absences:** As many parents know, reporting their students' absences can be quite tedious. VERTEX ensures that this process is simple.

# Instructions
### Students: 
  * **Sign-In:** Students will be expected sign-in using their apps.nsd.org emails. 
  * **Home Page:** Once the student has been successfully authenticated, they will immediately be brought to a home screen where they will be able to look at their events and their classes/activities. 
    * Upcoming events that the student is a part of will be displayed at the top of the home screen. All school events will also be displayed.
    * At the bottom, students can access all of their activties (clubs/sports). By clicking on one of these acitivities, students can look at Instagram posts associated with the club.
    * At the bottom, students can also access all of their classes. By clicking on one of these classes, students can message the teacher of this class.
  * **Calendar Page:** Students can navigate to the calendar page with a calendar icon. They will be able to view all of their upcoming events that they are a part of. The events will be displayed on a calendar and at the bottom of the screen (including the name, description, and times of the events). Events are color-coded based on the type of the event they are:
    * Purple: School Events
    * Pink: Sports Events
    * Yellow: Club Events
  * **Messaging:** Students can message their teachers. They will be able to upload photos and write text messages to get help on any items they need. Teachers that students students only have class with are available to message.

### Teachers
  * **Sign-In:** Teachers will be expected to sign-in using their nsd.org emails.
  * **Home Page** Once the teacher has been successfully authenticated, they will immediately be brought to a home screen where they will able to look at their events and the classes they teach.
    * Upcoming events that the teachers are advisors of will be displayed at the top of the home screen. All school events will also be displayed.
    * At the bottom, teachers can access all of the classes they teach. By clicking on one of these classes, teachers can see all of their students in the class, and have further access to message them.
  * **Calendar Page:** Teachers can navigate to the calendar page with a calendar icon. They will be able to view all of their upcoming events that they are a part of. The events will be similarly displayed to the student page. One additional feature will be accessible to teachers at the top of the Calendar page by clicking on the addition icon: the ability to request events.
    * Request events: Teachers will be able to request an event by inputting a subject, dscription, and time that the event will occur. The event will be reviewed and added into the database within a few hours.
  * **Messaging:** Teachers can message their students. They will have access to all of the features that come with messaging (e.g.g photo uploading) that students have.

### Parents
  * **Sign-In:** Parents will be expected to sign-in with their gmails.
  * **Home Page** One the parent has been successfully aunthenticated, they will be immediately be brought to a home screen where they will be able to look at their child(ren)'s upcoming events.
    * Upcoming events that the parent's child is a part of will be displayed at the top of the home screen. All school events will also be displayed.
    * At the bottom, parents can access their individual child(ren). Bu clicking on one child, teachers can report an absence for that child.
  * **Calendar Page:** Parents can navigate to the calendar page with a calendar icon. They will be able to view all of the upcoming events that their child(ren) are a part of. The events will be displayed to the student and teacher pages.
  * **Report Absences:** Parents will have the ability to report an absence of their child. They will have to fill out a short form and submit. The submission will be evaluated and be updated on the student's record.

### All Users
  * **Settings:** Each user will be able to navigate to the settings page by clicking on the settings icon. The user can do these actions:
    * The user will be able to change their pronouns if they wish to do so.
    * The user will be able to view the licensing & terms of agreement.
    * The user will be able to suggest feedback about the overall app.
    * The user will be able to look at help guide to navigate the app if they need to so.
    * The user will be able logout from the app. 
  * **ASB:** Each user will have access to the ASB page by clicking on the mortarboard icon. The user will have access to all of the school events and the ASB Instagram page

# Support
If any help is needed while navigating through the app, please contact: [ishita.mundra@gmail.com](ishita.mundra@gmail.com).

# RoadMap
Future releases include:
* Fully integrating Instagram into our app by directly accessing posts and placing them within our app.
* Allowing teachers to send messages to an entire class, rather than individual students.
* Updated UI to ensure the best possible user experiences.
* Deployment of app at North Creek High School and further expanding to other schools.
* Notifications for upcoming events and messages.
* Events from classes

# Authors and Acknowledgement
Three authors have significantly contributed their time and efforts to this app:
* Ishita Mundra
* Pragya Rana
* Rishitha Ravi
=======
# mad

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
>>>>>>> Pragya
