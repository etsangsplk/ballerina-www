// Create a simple hello world service
// that accepts name as a POST payload
import ballerina/http;

// Define an HTTP service bound to the endpoint
@http:ServiceConfig {
    basePath: "/"
}
service<http:Service> hello bind {port: 9090} {
    // Define a REST resource within the API
    @http:ResourceConfig {
        path: "/",
        methods: ["POST"]
    }
    // Parameters include a reference to the caller endpoint
    // and a struct with the request data
    hi (endpoint caller, http:Request request) {
        // Create empty response struct
        http:Response res;
        // Try to retrieve parameters
        var  payload = request.getTextPayload();
        // Different handling depending on if we got proper string or error
        match payload {
            string name => {res.setTextPayload("Hello " + name + "!\n");}
            error err => {res.setTextPayload(err.message);}
        }   
        // Return response, '->' signifies remote call
        // '_' means ignore the function return value
        _ = caller->respond (res);
    }
}