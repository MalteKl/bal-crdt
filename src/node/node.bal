import ballerina/http;
import ballerina/system;
import ballerina/io;
import ballerina/lang.'int as ints;
import cvrdt;

var nodeId = system:uuid();
cvrdt:GCounter testCounter = new (nodeId, 0);


public function main() {

    map<http:WebSocketClient> wsClients = {};

    var run = true;

    while (run) {
           
        io:println("1: Connect\n2: Increment\n3: Go offline\n4: Go online\n5: Exit");
        var optionStr = io:readln("Choice: ");
        var option = ints:fromString(optionStr);

        match option {

            1 => {
                var url = io:readln("\nWS Url: ");
                var wsClientEp = new http:WebSocketClient(url, config = {callbackService: ClientService});
                wsClients[url] = wsClientEp;
            }

            2 => {
                testCounter.increment();
                io:println(string `New value: ${testCounter.value()}`);
                foreach var wsClient in wsClients {
                    if(wsClient.isOpen()){
                        var err = wsClient->pushText(testCounter.count.toJsonString());
                    }
                }
            }

            3 => {               
                foreach var wsClient in wsClients {
                    
                    var err = wsClient->close();
                }   
            }

            4 => {
                foreach var [k, v] in wsClients.entries() {
                    
                    wsClients[k] = new (k, config = {callbackService: ClientService});
                }
            }

            5 => {
                run = false;
            }
        }
    }
}

service ClientService = @http:WebSocketServiceConfig {} service {

    resource function onText(http:WebSocketClient conn, string text, boolean finalFrame) {
        io:println(text);
    }
    resource function onError(http:WebSocketClient conn, error err) {
        io:println(err);
    }
};

