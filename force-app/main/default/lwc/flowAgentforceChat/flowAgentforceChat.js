import { LightningElement, track, api } from "lwc";
import createChatGenerations from "@salesforce/apex/ModelsAPIChatGenerations.createChatGenerations";
import { FlowAttributeChangeEvent } from "lightning/flowSupport";

export default class flowAgentforceChat extends LightningElement {
    @track messages = []; // Array to store chat messages
    @api messageOut; //String to output chat transcript
    @api labelText; //Label for message input
    @api messageCollection = []; //Array to store messages for flow output
    iconName = 'utility:copy' //Initial Copy Button Icon
    altText = 'Copy Button' //Initial Copy Button Alttext
    userMessage = ""; // User input message
    isLoading = false; // Track loading state
  
    // Handle user input change
    handleInputChange(event) {
      this.userMessage = event.target.value;
      this.iconName = 'utility:copy'
      this.altText = 'Copy Button'
    }
  
    // Scroll to the bottom of the chat container
    renderedCallback() {
      this.scrollToBottom();
    }
  
    // Handle send message button click
    handleSendMessage() {
      if (this.userMessage.trim()) {
        const userMessageObj = {
          id: this.messages.length + 1,
          text: this.userMessage,
          role: "user",
          isUser: true,
        };
  
        // Add user message to the messages array
        this.messages = [...this.messages, userMessageObj];
        this.updateMessageOut(); // Update messageOut property
        this.isLoading = true; // Show loading indicator
  
        // Prepare message array for API call
        let messageArray = this.messages.map((msg) => ({
          role: msg.isUser ? "user" : "assistant",
          message: msg.text,
        }));
  
        // Call Apex method to fetch chat response
        createChatGenerations({ input: JSON.stringify(messageArray) })
          .then((result) => {
            this.simulateTypingEffect(result);            
          })
          .catch((error) => {
            console.error("Error fetching bot response", JSON.stringify(error));
          })
          .finally(() => {
            this.isLoading = false; // Hide loading indicator
          });
  
        this.userMessage = ""; // Clear user input
      }
    }
  
    // Simulate typing effect for the chat response
    simulateTypingEffect(fullText) {
      const words = fullText.split(" ");
      let currentIndex = 0;
      let displayText = "";
  
      const intervalId = setInterval(() => {
        if (currentIndex < words.length) {
          displayText += words[currentIndex] + " ";
          const botResponseObj = {
            id: this.messages.length + 1,
            text: displayText.trim(),
            role: "assistant",
            isUser: false,
          };
          // Replace the last message if it’s the bot’s typing message
          if (currentIndex > 0) {
            this.messages.splice(this.messages.length - 1, 1, botResponseObj);
          } else {
            this.messages = [...this.messages, botResponseObj];
          }
          this.updateMessageOut(); // Update messageOut property
          this.scrollToBottom();
          currentIndex++;
        } else {
          clearInterval(intervalId);
        }
      }, 30); // Adjust typing speed (ms per word)
    }
    
    // Update the messageOut property to include all messages as a single string
    updateMessageOut() {
      // Push each message's text to the messageCollection
      this.messageCollection = this.messages.map((msg) => msg.text);
    
      // Join the texts to create a single string for messageOut
      this.messageOut = this.messageCollection.join(" ");
    
      // Trigger the flow event with the updated messageOut
      this._fireFlowEvent("messageOut", this.messageOut);

      // Trigger the flow event with the updated messageCollection
      this._fireFlowEvent("messageCollection", this.messageCollection);
    }
    // Scroll to the bottom of the chat container
    scrollToBottom() {
      const chatContainer = this.template.querySelector(".slds-scrollable_y");
      if (chatContainer) {
        chatContainer.scrollTop = chatContainer.scrollHeight;
      }
    }

    //Fires event to flow 
    _fireFlowEvent(eventName, data) {
      this.dispatchEvent(new FlowAttributeChangeEvent(eventName, data));
    }

    // Handle Copy Function
    handleCopy() {

      //console.log(
          //'Inside Handle Copy'
      //);

      if (
          navigator.clipboard && 
          window.isSecureContext
      ) {

          this.iconName = 'utility:check';
          this.altText = 'Text Copied';
          return navigator.clipboard.writeText(
              this.messageOut
          );

      }

  }

  addToMessageCollection(messageText) {
    // Check if the messageText is a string
    if (typeof messageText === 'string') {
      // Check if the messageCollection exists
      if (!this.messageCollection) {
        this.messageCollection = [];
      }
      // Add the messageText to the messageCollection
      this.messageCollection.push(messageText);
    } else {
      console.error('Invalid messageText type: ', typeof messageText);
    }
    this._fireFlowEvent("messageCollection", this.messageCollection);
  }

}