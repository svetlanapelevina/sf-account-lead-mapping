public class SObjectUtils {

    public static Object getFirstListElement(List<Object> objectList) {
        if (objectList.isEmpty()) {
            return null;
        }

        return objectList.get(0);
    }
}