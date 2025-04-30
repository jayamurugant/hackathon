public without sharing class ModelsAPIChatGenerations {
    // Decorate the method with @AuraEnabled to make it accessible from a Lightning component
    @AuraEnabled
    public static String createChatGenerations(String input) {
        System.debug(input);
        // Deserialize the input JSON string to a list of ChatMessage objects
        List<ChatMessage> messages = (List<ChatMessage>) JSON.deserialize(input, List<ChatMessage>.class);
        
        // Instantiate the API class
        aiplatform.ModelsAPI modelsAPI = new aiplatform.ModelsAPI();

        // Prepare the request and body objects
        aiplatform.ModelsAPI.createChatGenerations_Request request = new aiplatform.ModelsAPI.createChatGenerations_Request();
        aiplatform.ModelsAPI_ChatGenerationsRequest body = new aiplatform.ModelsAPI_ChatGenerationsRequest();

        // Specify model
        request.modelName = 'sfdc_ai__DefaultOpenAIGPT4OmniMini';

        // Create a list to hold chat messages
        List<aiplatform.ModelsAPI_ChatMessageRequest> messagesList = new List<aiplatform.ModelsAPI_ChatMessageRequest>();

        // Loop through the input messages and create message requests
        for (ChatMessage msg : messages) {
            if(msg.message != null){
                String mesg = 'Prompt: What is the intent of the customer message? \n Message:'+ msg.message + '\n Expected output: Cancel_Intent ,Sale_Intent, Upgrade_Intent, Cancel_Intent, Refund_Request and UNKNOWN for unclear intents' ; 
                System.debug(mesg);
                System.debug(msg.role );
                aiplatform.ModelsAPI_ChatMessageRequest messageRequest = new aiplatform.ModelsAPI_ChatMessageRequest();
                messageRequest.content = mesg; // Handle null message
                messageRequest.role = 'user'; // Handle null role
                messagesList.add(messageRequest);
            }
        }
        String response = '';
        if(!messagesList.isEmpty()){
            system.debug(messagesList);
        // Set the messages in the request body
        body.messages = messagesList;

        // Set the request body and model name
        request.body = body;
            system.debug(request);
        
        




        try {
            // Call the API and get the response
            aiplatform.ModelsAPI.createChatGenerations_Response apiResponse = modelsAPI.createChatGenerations(
                request
            );

            // Check that we have a non-null response
            if (
                apiResponse?.Code200?.generationDetails?.generations != null &&
                !apiResponse.Code200.generationDetails.generations.isEmpty()
            ) {
                // Set the variable from the response
                response = apiResponse.Code200.generationDetails.generations[0]
                    .content;
            } else {
                // Handle the case where response is null
                response = 'No content generated';
            }

        // Handle error
        } catch(Exception e) {
            System.debug('Response code: ' + e.getMessage());
            System.debug('The following exception occurred: ' + e);

            // Add error to the output
            response = 'Unable to get a valid response. Error code: ';
        }
        }
        
        return response;
    }
}