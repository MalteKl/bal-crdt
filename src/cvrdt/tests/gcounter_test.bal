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
function incrementTest() {

    // call increment once
    sut.increment();
    test:assertTrue(sut.value() == 1);

    // call increment three times
    sut.increment();
    sut.increment();
    sut.increment();
    test:assertTrue(sut.value() == 4);
}

@test:Config { before: "setup"}
function mergeTest() {

    // one map with 2 new values

    // one map with all values

}

//@test:Config { before: "beforeFunc", after: "afterFunc"}
function valueTest() {

}

