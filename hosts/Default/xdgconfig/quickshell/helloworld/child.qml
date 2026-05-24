Item {
    required property bool testBool

    onTestBoolChanged: {
        console.log("child:", testBool)
    }
}
