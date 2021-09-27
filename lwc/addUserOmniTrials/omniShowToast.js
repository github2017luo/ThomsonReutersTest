import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//create Es6 module
const showToast = (variant, mode, title, message) =>{

    const event = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,
        mode: mode
    });
    return event;
}
     
//const showAlert = () =>{
//    alert('inside show alert');
//}

//export module
export {showToast}