@isTest
public class ChatMessageTest {
    @isTest
    static void testChatMessageConstructor() {
        // Test the parameterized constructor
        String role = 'user';
        String message = 'Hello, how can I help you?';

        // Create an instance of ChatMessage using the parameterized constructor
        ChatMessage chatMessage = new ChatMessage(role, message);

        // Assert that the properties are set correctly
        System.assertEquals(role, chatMessage.role, 'The role should be set correctly.');
        System.assertEquals(message, chatMessage.message, 'The message should be set correctly.');
    }

    @isTest
    static void testChatMessageDefaultConstructor() {
        // Test the default constructor
        ChatMessage chatMessage = new ChatMessage();

        // Assert that the properties are null by default
        System.assertEquals(null, chatMessage.role, 'The role should be null by default.');
        System.assertEquals(null, chatMessage.message, 'The message should be null by default.');

        // Set the properties manually
        chatMessage.role = 'assistant';
        chatMessage.message = 'Sure, I can help you with that.';

        // Assert that the properties are updated correctly
        System.assertEquals('assistant', chatMessage.role, 'The role should be updated correctly.');
        System.assertEquals('Sure, I can help you with that.', chatMessage.message, 'The message should be updated correctly.');
    }
}