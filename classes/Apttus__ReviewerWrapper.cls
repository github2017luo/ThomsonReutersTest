/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ReviewerWrapper {
    @WebService
    webService List<Apttus.ReviewerWrapper.ContentControls> contentControls;
    @WebService
    webService String reviewerEmail;
    @WebService
    webService Id reviewerId;
    @WebService
    webService String reviewerName;
    global ReviewerWrapper(Id reviewerId, String reviewerName, String reviewerEmail, List<Apttus.ReviewerWrapper.ContentControls> contentControls) {

    }
global class ContentControls {
    @WebService
    webService Boolean allowEditing;
    @WebService
    webService String controlId;
}
}
