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
// Function to retrieve a specific programme by code
public function getProgramme(string programmeCode) returns error? {
    http:Response|error response = clientEP->get("/" + programmeCode);
    if (response is http:Response) {
        json programme = check response.getJsonPayload();
        io:println("Programme Details: ", programme);
    } else {
        io:println("Error retrieving programme: ", response.detail());
    }
}

// Function to update an existing programme
public function updateProgramme(Programme programme) returns error? {
    json updatedProgramme = {
        programmeCode: programme.programmeCode,
        title: programme.title,
        nqfLevel: programme.nqfLevel,
        faculty: programme.faculty,
        department: programme.department,
        registrationDate: programme.registrationDate
    };

    http:Response|error response = clientEP->put("/" + programme.programmeCode, updatedProgramme);
    if (response is http:Response) {
        io:println("Programme updated: ", response.getTextPayload());
    } else {
        io:println("Error updating programme: ", response.detail());
    }
}

// Function to delete a programme
public function deleteProgramme(string programmeCode) returns error? {
    http:Response|error response = clientEP->delete("/" + programmeCode);
    if (response is http:Response) {
        io:println("Programme deleted: ", response.getTextPayload());
    } else {
        io:println("Error deleting programme: ", response.detail());
    }
}

// Main function to test the client
public function main() returns error? {
    // Example Programme
    Programme newProgramme = {
        programmeCode: "08BCMS",
        title: "Engineering Fundamentals",
        nqfLevel: 6,
        faculty: "Engineering",
        department: "Civil Engineering",
        registrationDate: "2024-01-01"
    };

    // Call the API functions
    check addProgramme(newProgramme);
    check getAllProgrammes();
    check getProgramme("08BCMS");

    // Update example
    newProgramme.title = "Advanced Engineering";
    newProgramme.nqfLevel = 7;
    check updateProgramme(newProgramme);
    
    // Delete example
    check deleteProgramme("08BCMS");
}
