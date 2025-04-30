@isTest
public class ModelsAPIChatGenerationsTest {
    @isTest
    static void testCreateChatGenerations() {
        // Set the mock callout
        Test.setMock(HttpCalloutMock.class, new ModelsAPIGenerationHttpCalloutMock());

        // Prepare the input JSON string
        String input = JSON.serialize(new List<ChatMessage>{
            new ChatMessage('user', 'Can you give me a recipe for cherry pie?')
        });

        // Call the method to test
        String response = ModelsAPIChatGenerations.createChatGenerations(input);

        // Assert the response
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assert(response.contains('Can you give me a recipe for cherry pie?'), 'Response should contain the expected content');
    }

    // Helper class to simulate the ChatMessage structure
    public class ChatMessage {
        public String role;
        public String message;

        public ChatMessage(String role, String message) {
            this.role = role;
            this.message = message;
        }
    }
}