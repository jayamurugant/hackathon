import { getRecord } from "lightning/uiRecordApi";
import { LightningElement, api, track, wire } from "lwc";
import createChatGenerations from '@salesforce/apex/ModelsAPIChatGenerations.createChatGenerations';

const FIELDS = [
  "VoiceCall.CallType",
  "VoiceCall.FromPhoneNumber",
  "VoiceCall.ToPhoneNumber",
];
export default class LiveAgentConvo extends LightningElement {


     @track isTelephonyActionControlsDisabled = true;

  @api recordId;

  @wire(getRecord, { recordId: "$recordId", fields: FIELDS })
  voiceCall;

  payload = '{"key": "value"}';
  teleEvent = "No events received yet.";
  transcript = "No transcripts received yet.";
  previewPhoneNumber = "";
  addParticipantPhoneNumber = "";
  sendDigits = "";
  comboBoxHoldValue = "Initial_Caller";
  comboBoxResumeValue = "Initial_Caller";
  comboBoxRemoveParticipantValue = "Agent";
  comboBoxContactTypeValue = "PhoneNumber";
  comboBoxAddParticipantContactTypeValue = "PhoneNumber";
  hasRendered = false;

  intend = "UNKNOWN";
    constructor() {
    super();
    this.telephonyEventListener = this.onTelephonyEvent.bind(this);
  }
   
   renderedCallback() {
    this.subscribeToVoiceToolkit();
  }

    subscribeToVoiceToolkit() {
        const toolkitApi = this.template.querySelector('lightning-service-cloud-voice-toolkit-api');
        toolkitApi.addEventListener('transcript', this.telephonyEventListener);

    }
 onTelephonyEvent(event) {
    

    if (event.type === "transcript") {
      
      this.transcript = JSON.stringify(event.detail);
    try{
      console.log(this.transcript);
      const trans = JSON.parse(this.transcript);
      console.log(trans);
      const convoMessage =trans?.content?.text; 
      const role = trans?.sender?.role;
      console.log('convoMessg:'+convoMessage);
      console.log('role:'+role);
     // this.teleEvent = JSON.stringify(event);
      const input = [{
        role:role,
        message:convoMessage
      }]
      console.log(input);
      createChatGenerations({input: JSON.stringify(input)}).then(result =>{
          console.log('apex response'+JSON.stringify(result));
          const intent = JSON.stringify(result);
          if(intent && intent != 'UNKNOWN' && intent.includes('intent'))
          this.intend = intent;

      }).catch(e => {
          console.log('apex error :'+JSON.stringify(e));
      });
    }catch(e){
      console.log('js error:'+JSON.stringify(e));
    }
    }

  }


onInvokeNBA(event) {
    // Message must be in the format { key: 'value' }
    // Use in the Next Best Action strategy filter element with $Request.key
    // To learn more, see:
    // https://help.salesforce.com/articleView?id=nba_strategy_expressions.htm&type=5
    this.getToolkitApi().updateNextBestActions(
      this.recordId,
      JSON.parse(this.payload)
    );
  }


}