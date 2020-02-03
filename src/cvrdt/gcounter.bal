import ballerina/lang.'int as ints;

# Represents a CvRDT GCounter that uses a vector clock to maintain the system state.
# + count - Vector clock representing the system value. Indexed by node id
# + nodeId - The id of the local node
public type GCounter object{
    
    public map<int> count = {};

    public string nodeId;

    public function __init(string nodeId, int state) {
        
        self.nodeId = nodeId;
        self.count[nodeId] = state;
    }

    # Increments the integer of the respective node in the vector
    public function increment() {
        self.count[self.nodeId] = self.count.get(self.nodeId) + 1;
    }

    # Gets the human readable value of the system
    # + return - The sum of the values in the vector
    public function value() returns int {

        var sum = 0;
        foreach var value in self.count {
            
            sum += value;
        }
        
        return sum;
    }

    # Merges the incoming state with the local state
    # by building the corrdinate-wise max
    # + incoming - incoming changes to be merged
    public function merge(map<int> incoming) {

        foreach var nodeId in incoming.keys() {
            if(self.count.hasKey(nodeId)){
                self.count[nodeId] = ints:max(self.count.get(nodeId), incoming.get(nodeId));
            }
            else{
                self.count[nodeId] = incoming.get(nodeId);
            }
        }
    }
};