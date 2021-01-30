class JsonUtils {
  /// A very bad and basic check for a valid json
  static bool isValidJson(String json) {
    bool conditionA = json.startsWith("{") && json.endsWith("}");
    bool conditionB = json.startsWith("[") && json.endsWith("]");
    return conditionA || conditionB;
  }
}
