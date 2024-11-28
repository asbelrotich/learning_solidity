//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.2;
contract bookstore{
    address public owner;
    struct book{
        string title;
        string author;
        uint256 price;
        uint256 stock;
        bool isavailable;
    }
    mapping (uint256 => book) public books;
    uint256[] public bookIds;
    event bookpurchased(
        uint256 indexed  bookId, address indexed buyer, uint256 quantity, uint256 totalprice);
        modifier onlyOwner() {
            require(msg.sender ==owner, "Only owner can modify");
            _;        }
            modifier validbookId(uint256 _bookId) {
                require(_bookId > 0, "Book Id must be greater than zero");
                _;
            }
            constructor() {
                owner = msg.sender;
            }
            function addbook(
                uint256 _bookId,
                string memory _title,
                string memory _author,
                uint256 _price,
                uint256 _stock
            ) public onlyOwner validbookId(_bookId) {
                require(bytes(_title).length > 0, "Title cannot be empty");
                require(bytes(_author).length > 0, "Author cannot be empty");
                require(_price > 0, "Price must be greater than zero");
            }
}