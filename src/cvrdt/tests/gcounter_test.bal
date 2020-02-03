import ballerina/test;

const string localNodeId = "local";
const string testNodeId1 = "Node1";
const string testNodeId2 = "Node2";
const string testNodeId3 = "Node3";

GCounter sut = new GCounter(localNodeId, 0);

# Before test function
function setup() {

    sut = new GCounter(localNodeId, 0);
}

@test:Config { before: "setup"}
function increment_should_only_increment_local_node() {

    // call increment once
    sut.increment();
    test:assertEquals(sut.count[localNodeId], 1);

    // call increment three times
    sut.increment();
    sut.increment();
    sut.increment();
    test:assertEquals(sut.count[localNodeId], 4);
}

@test:Config { before: "setup"}
function merge_should_add_unknown_nodes() {

    // arrange
    map<int> localState = {};
    localState[localNodeId] =  1;
    localState[testNodeId1] = 2; 
    localState[testNodeId2] = 3;
    localState[testNodeId3] = 4;
    
    // act
    sut.merge(localState);

    // assert
    test:assertEquals(sut.count[localNodeId], 1);
    test:assertEquals(sut.count[testNodeId1], 2); 
    test:assertEquals(sut.count[testNodeId2], 3);
    test:assertEquals(sut.count[testNodeId3], 4);
}

@test:Config { before: "setup"}
function merge_should_update_state_with_max_value() {

    // arrange
    map<int> initialState = {};
    initialState[localNodeId] =  1;
    initialState[testNodeId1] = 2; 
    initialState[testNodeId2] = 3;
    initialState[testNodeId3] = 4;
    
    // add all nodes to the local node
    sut.merge(initialState);

    map<int> incomingState = {};
    incomingState[localNodeId] = 1; // unchanged
    incomingState[testNodeId1] = 3; // increased
    incomingState[testNodeId2] = 4; // increased
    incomingState[testNodeId3] = 3; // old state with lower value

    // act
    sut.merge(incomingState);

    // assert
    test:assertEquals(sut.count[localNodeId], 1);
    test:assertEquals(sut.count[testNodeId1], 3); 
    test:assertEquals(sut.count[testNodeId2], 4);
    test:assertEquals(sut.count[testNodeId3], 4);
}

@test:Config { before: "setup"}
function value_should_add_all_existing_values() {

    // arrange
    map<int> initialState = {};
    initialState[localNodeId] =  1;
    initialState[testNodeId1] = 2; 
    initialState[testNodeId2] = 3;
    initialState[testNodeId3] = 4;
    
    // add all nodes to the local node
    sut.merge(initialState);

    // act
    var value = sut.value();

    // assert
    test:assertEquals(value, 10);
}

