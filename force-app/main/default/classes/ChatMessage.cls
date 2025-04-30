public class ChatMessage {

    @AuraEnabled
    public String role;

    @AuraEnabled
    public String message;

    public ChatMessage() {
    }

    public ChatMessage(String role, String message) {
        this.role = role;
        this.message = message;
    }
}