import ballerina/http;
import ballerina/io;

// Base URL of the API
final string API_URL = "http://localhost:8081/programmes";

// Create a reusable HTTP client
http:Client clientEP = check new(API_URL);

// Define the Programme record
type Programme record {
    string programmeCode;
    string title;
    int nqfLevel;
    string faculty;
    string department;
    string registrationDate;
};

// Function to add a new programme
public function addProgramme(Programme programme) returns error? {
    json newProgramme = {
        programmeCode: programme.programmeCode,
        title: programme.title,
        nqfLevel: programme.nqfLevel,
        faculty: programme.faculty,
        department: programme.department,
        registrationDate: programme.registrationDate
    };

    // Send a POST request to add the new programme
    http:Response|error response = clientEP->post("/", newProgramme);

    // Check the response
    if (response is http:Response) {
        io:println("Programme added: ", response.getTextPayload());
    } else {
        io:println("Error adding programme: ", response.detail());
    }
}

// Function to retrieve all programmes
public function getAllProgrammes() returns error? {
    http:Response|error response = clientEP->get(""); // Use an empty string for the base URL
    if (response is http:Response) {
        json programmes = check response.getJsonPayload();
        io:println("All Programmes: ", programmes);
    } else {
        io:println("Error retrieving programmes: ", response.detail());
    }
}
resource isolated function post programmes(Programmes_body payload) returns http:Response|error {
        string resourcePath = string `/programmes`;
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        http:Response response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # Retrieve the details of a specific programme
    #
    # + return - Programme details 
    resource isolated function get programmes/[string programmeCode]() returns Programmes_body|error {
        string resourcePath = string `/programmes/${getEncodedUri(programmeCode)}`;
        Programmes_body response = check self.clientEp->get(resourcePath);
        return response;
    }
    # Update an existing programme
    #
    # + payload - Updated programme details
    # + return - Programme successfully updated 
    resource isolated function put programmes/[string programmeCode](Programmes_programmeCode_body payload) returns http:Response|error {
        string resourcePath = string `/programmes/${getEncodedUri(programmeCode)}`;
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        http:Response response = check self.clientEp->put(resourcePath, request);
        return response;
    }
    # Delete a programme's record
    #
    # + return - Programme successfully deleted 
    resource isolated function delete programmes/[string programmeCode]() returns http:Response|error {
        string resourcePath = string `/programmes/${getEncodedUri(programmeCode)}`;
        http:Response response = check self.clientEp-> delete(resourcePath);
        return response;
    }
    # Retrieve all programmes due for review
    #
    # + return - A list of programmes due for review 
    resource isolated function get programmes\-review() returns Programmes_body[]|error {
        string resourcePath = string `/programmes-review`;
        Programmes_body[] response = check self.clientEp->get(resourcePath);
        return response;
    }
    # Retrieve all programmes that belong to a specific faculty
    #
    # + return - A list of programmes in the specified faculty 
    resource isolated function get programmes/faculty/[string facultyName]() returns Programmes_body[]|error {
        string resourcePath = string `/programmes/faculty/${getEncodedUri(facultyName)}`;
        Programmes_body[] response = check self.clientEp->get(resourcePath);
        return response;
    }
    # Retrieve all courses
    #
    # + return - A list of courses 

