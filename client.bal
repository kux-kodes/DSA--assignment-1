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
