@isTest
public class ModelsAPIGenerationHttpCalloutMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();

        // Validate the request method and endpoint
        if (req.getMethod() == 'POST' && req.getEndpoint().contains('/einstein/platform/v1/models/')) {
            // Set the status code and response body
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json;charset=utf-8');

            // Mock response body with the expected structure
            res.setBody('{' +
                '"id": "014DFFD2-04B5-4765-8EA7-507585268CD3",' +
                '"generationDetails": {' +
                    '"generations": [' +
                        '{' +
                            '"id": "",' +
                            '"role": "user",' +
                            '"content": "Can you give me a recipe for cherry pie?",' +
                            '"timestamp": 1682536893,' +
                            '"parameters": {' +
                                '"finish_reason": "stop",' +
                                '"index": 0,' +
                                '"logprobs": null' +
                            '},' +
                            '"contentQuality": {' +
                                '"scanToxicity": {' +
                                    '"isDetected": false,' +
                                    '"categories": [' +
                                        '{' +
                                            '"categoryName": "profanity",' +
                                            '"score": 0' +
                                        '}' +
                                    ']' +
                                '}' +
                            '}' +
                        '}' +
                    '],' +
                    '"parameters": {' +
                        '"model": "gpt-3.5-turbo",' +
                        '"object": "text_completion",' +
                        '"usage": {' +
                            '"completion_tokens": 235,' +
                            '"prompt_tokens": 91,' +
                            '"total_tokens": 326' +
                        '}' +
                    '}' +
                '}' +
            '}');
        } else {
            // Handle unexpected requests
            res.setStatusCode(400);
            res.setBody('{"error": "Invalid request"}');
        }

        return res;
    }
}