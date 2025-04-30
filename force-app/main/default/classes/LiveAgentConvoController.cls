/**
* @File Name : LiveAgentConvoController.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : April 30, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | April 30, 2025 |   | Initial Version
**/

public class LiveAgentConvoController {
	@AuraEnabled
	public static void triggerConversationIntelligence(){
 	try {
          //  ConversationIntelligence.triggerRule('Customer_Rule');
            // Handle success or failure (e.g., logging or returning a status)
        } catch (Exception e) {
            // Handle any exceptions (e.g., logging the error)
            System.debug('Error triggering CI rule: ' + e.getMessage());
            // Optionally throw an exception back to the LWC for handling
        }		
	}
}