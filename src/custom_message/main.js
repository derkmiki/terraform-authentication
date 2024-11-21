'use strict';

exports.handler = async function (event) {
    console.log(event);
    throw new Error("Cannot authenticate users from this user pool app client");
    return event;
}