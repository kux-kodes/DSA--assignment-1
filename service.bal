import ballerina/http;

public type Programme readonly & record {
    string title;
    string code;
    int NQFLevel;
    string faculty;
    int year;
};


table<Programme> key(code) programmes = table [];


function getCurrentYear() returns int {
    return 2024; // Manually adjust this year if necessary
}


function isDueForReview(Programme programme) returns boolean {
    int currentYear = getCurrentYear();
    int nextReviewYear = programme.year + 5;
    return nextReviewYear <= currentYear;
}


function programmeToJson(Programme programme) returns json {
    return {
        code: programme.code,
        title: programme.title,
        NQFLevel: programme.NQFLevel,
        faculty: programme.faculty,
        year: programme.year
    };
}


service /programmes on new http:Listener(8080) {

    e
    resource function post addProgrammes(http:Caller caller, http:Request req) returns error? {
        json|error payload = req.getJsonPayload();

        if (payload is error) {
            http:Response res = new;
            res.statusCode = 400; // Bad Request
            res.setPayload("Invalid JSON payload");
            check caller->respond(res);
            return;
        }

        Programme newProgramme = check payload.cloneWithType(Programme);

        
        if programmes.hasKey(newProgramme.code) {
            http:Response res = new;
            res.statusCode = 409; // Conflict
            res.setPayload("Programme with code " + newProgramme.code + " already exists.");
            check caller->respond(res);
        } else {
            
            programmes.add(newProgramme);
            http:Response res = new;
                        res.statusCode = 201; // Created
            res.setPayload("Programme successfully added.");
            check caller->respond(res);
        }
    }
   // PUT method to update an existing programme
    resource function put updateProgrammes/[string programmeCode](http:Caller caller, http:Request req) returns error? {
    json|error jsonPayload = req.getJsonPayload();

    if (jsonPayload is error) {
        http:Response res = new;
        res.statusCode = 400; // Bad Request
        res.setPayload("Invalid JSON payload");
        check caller->respond(res);
        return;
    }

    Programme updatedProgramme = check jsonPayload.cloneWithType(Programme);

    // Check if the programme with the given code exists in the table
    Programme? existingProgramme = programmes[programmeCode];

    if (existingProgramme is Programme) {
        // Use the `put` method to update the programme in the table
        check programmes.put(updatedProgramme);

        http:Response res = new;
        res.statusCode = 200; // OK
        res.setPayload("Programme updated successfully.");
        check caller->respond(res);

    } else {
        // If the programme does not exist, respond with a 404 error
        http:Response res = new;
        res.statusCode = 404; // Not Found
        res.setPayload("Programme with code " + programmeCode + " not found.");
        check caller->respond(res);
    }
}
 // Retrieve the details of a specific programme
    resource function get [string programmeCode](http:Caller caller, http:Request req) returns error? {
        Programme[] results = from var p in programmes
                              where p.code == programmeCode
                              select p;
        if (results.length() == 0) {
            http:Response res = new;
            res.statusCode = 404; // Not Found
            res.setPayload("Programme: " + programmeCode + " not found");
            check caller->respond(res);
        } else {
            json programmeJson = programmeToJson(results[0]);
            http:Response res = new;
            res.setPayload(programmeJson);
            check caller->respond(res);
        }
    }

    
    resource function delete byProgrammeCode/[string programmeCode](http:Caller caller, http:Request req) returns error? {
        Programme? removedProgramme = programmes.remove(programmeCode);
        if (removedProgramme is ()) {
            http:Response res = new;
            res.statusCode = 404; // Not Found
            res.setPayload("Programme: " + programmeCode + " not found");
            check caller->respond(res);
        } else {
            http:Response res = new;
            res.statusCode = 204; // No Content
            check caller->respond(res);
        }
    }

   s
resource function get allProgrammes(http:Caller caller, http:Request req) returns error? {
    Programme[] allProgrammes = from var p in programmes
                                select p;
    if (allProgrammes.length() == 0) {
        http:Response res = new;
        res.statusCode = 404; // Not Found
        res.setPayload("No programmes found");
        check caller->respond(res);
    } else {
        json programmesJson = allProgrammes.map(programmeToJson);
        http:Response res = new;
        res.setPayload(programmesJson);
        check caller->respond(res);
    }
}


   
    resource function get faculty/[string faculty](http:Caller caller) returns error? {
        Programme[] programmesInFaculty = from Programme programme in programmes
                                          where programme.faculty == faculty
                                          select programme;

        if (programmesInFaculty.length() == 0) {
            http:Response res = new;
            res.statusCode = 404; // Not Found
            res.setPayload("No programmes found for faculty: " + faculty);
            check caller->respond(res);
        } else {
            json facultyProgrammesJson = programmesInFaculty.map(programmeToJson);
            http:Response res = new;
            res.setPayload(facultyProgrammesJson);
            check caller->respond(res);
        }
    }

 
    resource function get programmesDueForReview(http:Caller caller, http:Request req) returns error? {
        Programme[] dueForReviewProgrammes = from Programme p in programmes
                                             where isDueForReview(p)
                                             select p;

        if (dueForReviewProgrammes.length() == 0) {
            http:Response res = new;
            res.statusCode = 404; // Not Found
            res.setPayload("No programmes due for review");
            check caller->respond(res);
        } else {
            json dueForReviewJson = dueForReviewProgrammes.map(programmeToJson);
            http:Response res = new;
            res.setPayload(dueForReviewJson);
            check caller->respond(res);
        }
    }
}




