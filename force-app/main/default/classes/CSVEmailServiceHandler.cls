/* 
* @author Shekhar Vinayak
* @date 17/06/2025 
* @description Handler delegates all processing to the service layer.
*/

public class CSVEmailServiceHandler implements Messaging.InboundEmailHandler {

    public Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        Boolean found = false;

        try {
            // Only extract the CSV blob and pass to service
            if (email.textAttachments != null) {
                for (Messaging.InboundEmail.TextAttachment attachment : email.textAttachments) {
                    if (attachment.filename != null && attachment.filename.toLowerCase().endsWith('.csv')) {
                        Blob csvBlob = Blob.valueOf(attachment.body);
                        System.debug('CSV text attachment found: ' + attachment.filename);

                        // Delegate to service, passing the blob
                        IEmailService service = (IEmailService)Type.forName(EmailServUtility.getServiceClassName('BFSA')).newInstance();
                        service.proccessAttachment(csvBlob);

                        found = true;
                        break;
                    }
                }
            }

            if (!found) {
                result.success = false;
                System.debug('No CSV attachment found');
                return result;
            }
            result.success = true;
        } catch (Exception ex) {
            result.success = false;
            System.debug('Email handler error: ' + ex.getMessage() + ' ' + ex.getStackTraceString() + ' ' + ex.getTypeName());
        }

        return result;
    }
}