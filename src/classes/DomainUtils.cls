public class DomainUtils {

    public static String getEmailDomain(String email) {
        if (String.isBlank(email) || email.contains('@') == false) {
            return null;
        }

        return email.substring(email.indexOf('@') + 1);
    }
}