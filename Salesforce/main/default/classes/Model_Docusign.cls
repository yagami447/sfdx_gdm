public class Model_Docusign {
    
    public String status {get; set;}
    public String emailSubject {get; set;}
    public List<Document> documents {get; set;}
    public Recipients recipients {get; set;}
    
    public class Document {
        public Integer documentId {get; set;}
        public String name {get; set;}
        public String documentBase64 {get; set;}
        public String fileExtension {get; set;}
    }
    
    public class Recipients {
        public List<Signer> signers {get; set;}
    }
    
    public class Signer {
        public String name {get; set;}
        public String email {get; set;}
        public Integer recipientId {get; set;}
        public Integer routingOrder {get; set;}
        public Tabs tabs {get; set;}
        public EmailNotification emailNotification {get; set;}
        public List<RecipientSignatureProviders> recipientSignatureProviders {get; set;}
    }
    
    public class Tabs {
        public List<SignHereTab> signHereTabs {get; set;}
        public List<DateSignedTab> dateSignedTabs {get; set;}
        public List<InitialHereTab> initialHereTabs {get; set;}
    }
    
    public class SignHereTab {
        public Integer xPosition {get; set;}
        public Integer yPosition {get; set;}
        public Integer documentId {get; set;}
        public Integer pageNumber {get; set;}
        public String anchorString {get; set;}
        public Integer anchorXOffset {get; set;}
        public Integer anchorYOffset {get; set;}
        public String anchorIgnoreIfNotPresent {get; set;}
        public String anchorUnits {get; set;}
    }
    
    public class InitialHereTab {
        public Integer documentId {get; set;}
        public String anchorString {get; set;}
        public Decimal anchorXOffset {get; set;}
        public Decimal anchorYOffset {get; set;}
        public String anchorIgnoreIfNotPresent {get; set;}
        public String anchorUnits {get; set;}
    }
    
    public class DateSignedTab {
        public Integer xPosition {get; set;}
        public Integer yPosition {get; set;}
        public Integer documentId {get; set;}
        public Integer pageNumber {get; set;}
        public String anchorString {get; set;}
        public Integer anchorXOffset {get; set;}
        public Integer anchorYOffset {get; set;}
        public String anchorIgnoreIfNotPresent {get; set;}
        public String anchorUnits {get; set;}
        public String font {get; set;}
        public String fontSize {get; set;}
        public String bold {get; set;}
    }
    
    public class EmailNotification {
        public String emailBody {get; set;}
        public String emailSubject {get; set;}
        public String supportedLanguage {get; set;}
    }
    
    public class RecipientSignatureProviders {
        public String signatureProviderName {get; set;}
    }
}