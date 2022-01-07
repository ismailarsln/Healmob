class BodyHelper {
    static checkArgumentsExist() {
        var conditionResult = false;
        for (var i = 0; i < arguments.length; i++) {
            conditionResult = (arguments[i] == undefined) || (arguments[i] == null);
        }
        return conditionResult;
    }

    static isStringJustNumbers(stringInput) {
        return String(stringInput).match(/^[0-9]+$/) != null
    }
}

module.exports = BodyHelper;