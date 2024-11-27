// SPDX-License-Identifier: GPL 3.0
pragma solidity ^0.8.2;
// struct book (id, Title, Isbn, Price, author, stock, isavailable)
//bookstore has owner which is the main address
//
contract Bookstore {
    address public owner;
    struct book{
        string title;
        string author;
        uint price;
        uint256 stock;
        bool isavailable;
    }
    mapping (uint256 => book) public books;
    uint256[] public bookIds;

    event bookadded(uint256 indexed bookId, string title, string author, uint256 price, uint256 stock);
    event bookpurchased(uint256 indexed bookId, address indexed buyer, uint256 quantity);
    constructor () {
        owner = msg.sender;
    }
    function addbook(uint256 _bookId, string memory _title, string memory _author, uint256 _price, uint256 _stock) public {
      require(books[_bookId].price == 0, "Book already exixts with tis ID!");
      books[_bookId] = book({
        title: _title,
        author: _author,
        price: _price,
        stock: _stock,
        isavailable: _stock > 0
      });
      bookIds.push(_bookId);
      emit bookadded(_bookId, _title, _author, _price, _stock);
    }
    function getbook(uint256 _bookId) public view returns (string memory, string memory, uint256, uint256, bool) {
        book memory Book = books[_bookId];
        return (Book.title, Book.author, Book.price, Book.stock, Book.isavailable);
    }
    function buybook(uint256 _bookId, uint256 _quantity, uint256 _amount) public payable {
        book storage Book = books[_bookId];
        require(Book.isavailable, "This book is not available");
        require(Book.stock >= _quantity, "Not enough stock available!");
        require(_amount == Book.price * _quantity, "Incorrect payment amount!");
        
        Book.stock -= _quantity;
        if (Book.stock == 0) {
            Book.isavailable = false;
        }
        payable (owner).transfer(msg.value);
        emit bookpurchased(_bookId, msg.sender, _quantity);
    }
}