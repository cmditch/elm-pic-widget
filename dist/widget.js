function initWidget(elmApp, elementId, callback) {
    app = elmApp.Main.embed(elementId);
    app.ports.messageUserland.subscribe(callback);
}