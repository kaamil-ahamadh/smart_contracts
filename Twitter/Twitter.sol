// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

contract Twitter {

    address public owner;
    uint private counter;

    constructor() {
        owner = msg.sender;
        counter = 0;
    }

    struct Tweet {
        uint id;
        address tweetSender;
        string tweetText;
        string tweetImage;
    }

    event TweetCreated(
        uint id,
        address indexed tweetSender,
        string tweetText,
        string tweetImage
    );

    event TweetEdited(
        uint id,
        address indexed tweetSender,
        string oldTweetText,
        string newTweetText,
        string tweetImage
    );

    event TweetDeleted(
        uint id,
        address indexed tweetSender,
        string tweetText,
        string tweetImage
    );

    mapping(uint => Tweet) private tweets;

    function sendTweet(string memory _tweetText, string memory _tweetImage) external {

        //add tweet to tweets
        tweets[counter] = Tweet(counter, msg.sender, _tweetText, _tweetImage);

        emit TweetCreated(counter, msg.sender, _tweetText, _tweetImage);

        counter++;
    }

    function getTweet(uint _id) external view returns(uint, address, string memory, string memory) {
        require(_id < counter, "No Such tweet");

        //get Tweet
        Tweet storage tweet = tweets[_id];

        return (tweet.id, tweet.tweetSender, tweet.tweetText, tweet.tweetImage);
    }

    function editTweet(uint _id, string memory _tweetText) external {
        require(_id < counter, "No Such tweet");

        //get Tweet and ensure he is a sender of the tweet or owner
        Tweet memory tweet = tweets[_id];
        require(msg.sender == tweet.tweetSender, "Only tweet sender can edit his tweet");

        //emit TweetEdited event
        emit TweetEdited(tweet.id, tweet.tweetSender, tweet.tweetText, _tweetText, tweet.tweetImage);

        //edit tweet
        tweets[_id].tweetText = _tweetText;
    }

    function deleteTweet(uint _id) external {
        require(_id < counter, "No Such tweet");

        //get Tweet
        Tweet memory tweet = tweets[_id];
        require(msg.sender == tweet.tweetSender || msg.sender == owner, "Only tweet sender or owner can delete this tweet");

        //emit TweetDeleted event
        emit TweetDeleted(tweet.id, tweet.tweetSender, tweet.tweetText, tweet.tweetImage);

        //delete tweet
        delete tweets[_id];
    }
}
